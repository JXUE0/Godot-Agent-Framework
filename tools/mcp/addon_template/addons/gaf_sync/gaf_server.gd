# gaf_server.gd
# 🏢 GODOT AGENT FRAMEWORK - SYNC ENGINE (GAF-SYNC) V1.1.0
# Mode: Pure TCP Client | Port: 1342 (Bridge) | GAF Native | Localhost Only

@tool
extends Node

var port := 1342
var tcp_client := StreamPeerTCP.new()
var handler: Node = null
var reconnect_timer := 0.0
const RECONNECT_INTERVAL := 3.0
var _connected := false
var _buffer := ""

func _enter_tree() -> void:
    # Initialize GAF Handler
    var plugin = Engine.get_meta("GAF_SYNC_PLUGIN") if Engine.has_meta("GAF_SYNC_PLUGIN") else null
    handler = preload("gaf_handler.gd").new(plugin)
    add_child(handler)
    _try_connect()

func _try_connect() -> void:
    var err = tcp_client.connect_to_host("127.0.0.1", port)
    if err == OK:
        print("GAF-Sync Engine (TCP): Connecting to Bridge at 127.0.0.1:", port, "...")
    else:
        printerr("GAF-Sync Engine (TCP): Failed to initiate connection.")

func _process(delta: float) -> void:
    tcp_client.poll()
    var status = tcp_client.get_status()

    match status:
        StreamPeerTCP.STATUS_CONNECTED:
            if not _connected:
                _connected = true
                print("GAF-Sync Engine (TCP): Connected to GAF-Bridge! 📡⚡")
            
            while tcp_client.get_available_bytes() > 0:
                var packet = tcp_client.get_utf8_string(tcp_client.get_available_bytes())
                _buffer += packet
                
            if _buffer.contains("\n"):
                var messages = _buffer.split("\n")
                _buffer = messages[messages.size() - 1]
                messages.remove_at(messages.size() - 1)
                
                for msgText in messages:
                    if not msgText.strip_edges().is_empty():
                        _handle_message(msgText)
                
        StreamPeerTCP.STATUS_ERROR, StreamPeerTCP.STATUS_NONE:
            if _connected:
                _connected = false
                print("GAF-Sync Engine (TCP): Disconnected. 💤")
                
            reconnect_timer += delta
            if reconnect_timer >= RECONNECT_INTERVAL:
                reconnect_timer = 0.0
                _try_connect()

        StreamPeerTCP.STATUS_CONNECTING:
            pass

func _handle_message(message_text: String) -> void:
    var json = JSON.new()
    if json.parse(message_text) == OK:
        var data = json.get_data()
        var req_id = data.get("id", -1)
        var method = data.get("method", "")
        var params = data.get("params", {})
        
        # Dispatch to GAF Handler
        var result = handler.process_request(method, params)
        _send_response(req_id, result)
    else:
        printerr("GAF-Sync Engine (TCP): JSON parse error.")

func _send_response(id: Variant, result: Dictionary) -> void:
    var response = {
        "jsonrpc": "2.0",
        "id": id,
        "result": result
    }
    # Important: Frame with \n for the Bridge to split properly
    tcp_client.put_utf8_string(JSON.stringify(response) + "\n")

func _exit_tree() -> void:
    tcp_client.disconnect_from_host()
    if handler:
        handler.queue_free()
    print("GAF-Sync Engine: Shutdown. 🛑")
