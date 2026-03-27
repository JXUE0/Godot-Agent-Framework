# gaf_sync.gd
# 🏢 GODOT AGENT FRAMEWORK - SYNC ENGINE (GAF-SYNC) V1.0.0
# Port: 1342 (WebSocket) | Protocol: GAF-V1

@tool
extends EditorPlugin

var server_node: Node = null

func _enter_tree() -> void:
    # Use Engine Meta to be accessible globally by editor tools
    Engine.set_meta("GAF_SYNC_PLUGIN", self)
    
    # Initialize the Sync Server Node
    server_node = preload("res://addons/gaf_sync/gaf_server.gd").new()
    add_child(server_node)
    
    print("GAF-Sync Engine: Initialized on port 1342. 📡🕹️⚡")

func _exit_tree() -> void:
    if server_node:
        server_node.queue_free()
    
    if Engine.has_meta("GAF_SYNC_PLUGIN"):
        Engine.remove_meta("GAF_SYNC_PLUGIN")
    
    print("GAF-Sync Engine: Shutdown. 💤")

# Global access to EditorInterface for the AI commands
func get_editor_interface() -> EditorInterface:
    return get_editor_interface()
