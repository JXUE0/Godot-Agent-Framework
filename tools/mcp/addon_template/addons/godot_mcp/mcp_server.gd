@tool
extends EditorPlugin

var tcp_server := TCPServer.new()
var port := 9081  # Configurable via ProjectSettings
var handshake_timeout := 3000 # ms
var debug_mode := true
var log_detailed := true  # Enable detailed logging
var command_handler = null  # Command handler reference
var allow_remote_connections := false
var require_auth := true
var auth_token := ""
var allow_unsafe_commands := false

signal client_connected(id)
signal client_disconnected(id)
signal command_received(client_id, command)

class WebSocketClient:
	var tcp: StreamPeerTCP
	var id: int
	var ws: WebSocketPeer
	var state: int = -1 # -1: handshaking, 0: connected, 1: error/closed
	var handshake_time: int
	var last_poll_time: int
	var authenticated: bool = false
	var remote_host: String = ""
	
	func _init(p_tcp: StreamPeerTCP, p_id: int, p_remote_host: String):
		tcp = p_tcp
		id = p_id
		handshake_time = Time.get_ticks_msec()
		remote_host = p_remote_host
	
	func upgrade_to_websocket() -> bool:
		ws = WebSocketPeer.new()
		var err = ws.accept_stream(tcp)
		return err == OK

var clients := {}
var next_client_id := 1

func _enter_tree():
	# Store plugin instance for EditorInterface access
	Engine.set_meta("GodotMCPPlugin", self)
	_load_security_settings()
	
	print("\n=== MCP SERVER STARTING ===")
	
	# Initialize the command handler
	print("Creating command handler...")
	command_handler = preload("res://addons/godot_mcp/command_handler.gd").new()
	command_handler.name = "CommandHandler"
	add_child(command_handler)
	
	# Connect signals
	print("Connecting command handler signals...")
	self.connect("command_received", Callable(command_handler, "_handle_command"))
	
	# Start WebSocket server
	var err = tcp_server.listen(port)
	if err == OK:
		print("Listening on port", port)
		set_process(true)
	else:
		printerr("Failed to listen on port", port, "error:", err)
	
	print("=== MCP SERVER INITIALIZED ===\n")

func _load_security_settings() -> void:
	port = int(ProjectSettings.get_setting("addons/godot_mcp/port", 9081))
	allow_remote_connections = bool(ProjectSettings.get_setting("addons/godot_mcp/allow_remote_connections", false))
	require_auth = bool(ProjectSettings.get_setting("addons/godot_mcp/require_auth", true))
	auth_token = str(ProjectSettings.get_setting("addons/godot_mcp/auth_token", "")).strip_edges()
	allow_unsafe_commands = bool(ProjectSettings.get_setting("addons/godot_mcp/allow_unsafe_commands", false))

	if require_auth and auth_token.is_empty():
		printerr("[Godot MCP] require_auth=true but auth_token is empty. Disabling auth requirement for this session.")
		require_auth = false

func _is_local_host(host: String) -> bool:
	return host == "127.0.0.1" or host == "::1" or host == "localhost"

func _send_auth_required(client: WebSocketClient, req_id = null) -> void:
	if req_id != null:
		client.ws.send_text(JSON.stringify({
			"jsonrpc": "2.0",
			"id": req_id,
			"error": {
				"code": -32001,
				"message": "Authentication required"
			}
		}))
	else:
		client.ws.send_text(JSON.stringify({
			"status": "error",
			"message": "Authentication required. Send {\"type\":\"auth\",\"params\":{\"token\":\"...\"}} first."
		}))

func _handle_legacy_auth(client: WebSocketClient, data: Dictionary) -> void:
	var params = data.get("params", {})
	var token = str(params.get("token", ""))
	var cmd_id = str(data.get("commandId", ""))
	var ok = (not require_auth) or (token == auth_token)
	if ok:
		client.authenticated = true
		client.ws.send_text(JSON.stringify({
			"status": "success",
			"result": {"authenticated": true},
			"commandId": cmd_id
		}))
	else:
		client.ws.send_text(JSON.stringify({
			"status": "error",
			"message": "Invalid authentication token",
			"commandId": cmd_id
		}))

func _handle_jsonrpc_auth(client: WebSocketClient, data: Dictionary) -> void:
	var params = data.get("params", {})
	var token = str(params.get("token", ""))
	var req_id = data.get("id")
	var ok = (not require_auth) or (token == auth_token)
	if ok:
		client.authenticated = true
		client.ws.send_text(JSON.stringify({
			"jsonrpc": "2.0",
			"id": req_id,
			"result": {"authenticated": true}
		}))
	else:
		client.ws.send_text(JSON.stringify({
			"jsonrpc": "2.0",
			"id": req_id,
			"error": {
				"code": -32002,
				"message": "Invalid authentication token"
			}
		}))

func _exit_tree():
	# Remove plugin instance from Engine metadata
	if Engine.has_meta("GodotMCPPlugin"):
		Engine.remove_meta("GodotMCPPlugin")
	
	if tcp_server and tcp_server.is_listening():
		tcp_server.stop()
	
	clients.clear()
	
	print("=== MCP SERVER SHUTDOWN ===")

func _log(client_id, message):
	if log_detailed:
		print("[Client ", client_id, "] ", message)

func _process(_delta):
	if not tcp_server.is_listening():
		return
	
	# Poll for new connections
	if tcp_server.is_connection_available():
		var tcp = tcp_server.take_connection()
		var remote_host = tcp.get_connected_host()
		if not allow_remote_connections and not _is_local_host(remote_host):
			print("[Rejected] Remote connection from ", remote_host)
			tcp.disconnect_from_host()
		else:
			var id = next_client_id
			next_client_id += 1
			
			var client = WebSocketClient.new(tcp, id, remote_host)
			client.authenticated = not require_auth
			clients[id] = client
			
			print("[Client ", id, "] New TCP connection from ", remote_host)
			
			# Try to upgrade immediately
			if client.upgrade_to_websocket():
				print("[Client ", id, "] WebSocket handshake started")
			else:
				print("[Client ", id, "] Failed to start WebSocket handshake")
				clients.erase(id)
	
	# Update clients
	var current_time = Time.get_ticks_msec()
	var ids_to_remove := []
	
	for id in clients:
		var client = clients[id]
		client.last_poll_time = current_time
		
		# Process client based on its state
		if client.state == -1: # Handshaking
			if client.ws != null:
				# Poll the WebSocket peer
				client.ws.poll()
				
				# Check WebSocket state
				var ws_state = client.ws.get_ready_state()
				if debug_mode:
					_log(id, "State: " + str(ws_state))
					
				if ws_state == WebSocketPeer.STATE_OPEN:
					print("[Client ", id, "] WebSocket handshake completed")
					client.state = 0
					
					# Emit connected signal
					emit_signal("client_connected", id)
					
					# Send welcome message
					var msg = JSON.stringify({
						"type": "welcome",
						"message": "Welcome to Godot MCP WebSocket Server"
					})
					client.ws.send_text(msg)
					
				elif ws_state != WebSocketPeer.STATE_CONNECTING:
					print("[Client ", id, "] WebSocket handshake failed, state: ", ws_state)
					ids_to_remove.append(id)
				
				# Check for handshake timeout
				elif current_time - client.handshake_time > handshake_timeout:
					print("[Client ", id, "] WebSocket handshake timed out")
					ids_to_remove.append(id)
			else:
				# If TCP is still connected, try upgrading
				if client.tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED:
					if client.upgrade_to_websocket():
						print("[Client ", id, "] WebSocket handshake started")
					else:
						print("[Client ", id, "] Failed to start WebSocket handshake")
						ids_to_remove.append(id)
				else:
					print("[Client ", id, "] TCP disconnected during handshake")
					ids_to_remove.append(id)
		
		elif client.state == 0: # Connected
			# Poll the WebSocket
			client.ws.poll()
			
			# Check state
			var ws_state = client.ws.get_ready_state()
			if ws_state != WebSocketPeer.STATE_OPEN:
				print("[Client ", id, "] WebSocket connection closed, state: ", ws_state)
				emit_signal("client_disconnected", id)
				ids_to_remove.append(id)
				continue
			
			# Process messages
			while client.ws.get_available_packet_count() > 0:
				var packet = client.ws.get_packet()
				var text = packet.get_string_from_utf8()
				
				print("[Client ", id, "] RECEIVED RAW DATA: ", text)
				
				# Parse as JSON
				var json = JSON.new()
				var parse_result = json.parse(text)
				_log(id, "JSON parse result: " + str(parse_result))
				
				if parse_result == OK:
					var data = json.get_data()
					_log(id, "Parsed JSON: " + str(data))
					
					# Handle JSON-RPC protocol
					if data.has("jsonrpc") and data.get("jsonrpc") == "2.0":
						# Handle ping method
						if data.has("method") and data.get("method") == "ping":
							print("[Client ", id, "] Received PING with id: ", data.get("id"))
							var response = {
								"jsonrpc": "2.0",
								"id": data.get("id"),
								"result": null  # FastMCP expects null result for pings
							}
							var response_text = JSON.stringify(response)
							var send_result = client.ws.send_text(response_text)
							print("[Client ", id, "] SENDING PING RESPONSE: ", response_text, " (result: ", send_result, ")")
						elif data.has("method") and data.get("method") == "auth":
							_handle_jsonrpc_auth(client, data)
						elif require_auth and not client.authenticated:
							_send_auth_required(client, data.get("id"))
						
						# Handle other MCP commands
						elif data.has("method"):
							var method_name = data.get("method")
							var params = data.get("params", {})
							var req_id = data.get("id")
							
							print("[Client ", id, "] Processing JSON-RPC method: ", method_name)
							
							# For now, just send a generic success response
							# TODO: Route these to command handler as well
							var response = {
								"jsonrpc": "2.0",
								"id": req_id,
								"result": {
									"status": "success",
									"message": "Command processed"
								}
							}
							
							var response_text = JSON.stringify(response)
							var send_result = client.ws.send_text(response_text)
							print("[Client ", id, "] SENT RESPONSE: ", response_text, " (result: ", send_result, ")")
					
					# Handle legacy command format - This is what Claude Code uses
					elif data.has("type"):
						var cmd_type = data.get("type")
						var params = data.get("params", {})
						var cmd_id = data.get("commandId", "")

						if cmd_type == "auth":
							_handle_legacy_auth(client, data)
							continue

						if require_auth and not client.authenticated:
							_send_auth_required(client)
							continue

						if cmd_type == "execute_editor_script" and not allow_unsafe_commands:
							client.ws.send_text(JSON.stringify({
								"status": "error",
								"message": "execute_editor_script is disabled by server policy",
								"commandId": cmd_id
							}))
							continue
						
						print("[Client ", id, "] Processing command: ", cmd_type)
						
						# Route command to command handler via signal
						# The command handler will handle the response via send_response
						emit_signal("command_received", id, data)
				else:
					print("[Client ", id, "] Failed to parse JSON: ", json.get_error_message())
	
	# Remove clients that need to be removed
	for id in ids_to_remove:
		clients.erase(id)

# Function for command handler to send responses back to clients
func send_response(client_id: int, response: Dictionary) -> int:
	if not clients.has(client_id):
		print("Error: Client %d not found" % client_id)
		return ERR_DOES_NOT_EXIST
	
	var client = clients[client_id]
	var json_text = JSON.stringify(response)
	
	print("Sending response to client %d: %s" % [client_id, json_text])
	
	if client.ws.get_ready_state() != WebSocketPeer.STATE_OPEN:
		print("Error: Client %d connection not open" % client_id)
		return ERR_UNAVAILABLE
	
	var result = client.ws.send_text(json_text)
	if result != OK:
		print("Error sending response to client %d: %d" % [client_id, result])
	
	return result

func is_server_active() -> bool:
	return tcp_server.is_listening()

func stop_server() -> void:
	if is_server_active():
		tcp_server.stop()
		clients.clear()
		print("MCP WebSocket server stopped")
		
func get_port() -> int:
	return port

