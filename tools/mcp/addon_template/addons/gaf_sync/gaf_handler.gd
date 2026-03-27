# gaf_handler.gd
# 🏢 GODOT AGENT FRAMEWORK - SYNC ENGINE (GAF-SYNC) V1.0.0
# Translation layer between AI JSON requests and Godot Editor API.

@tool
extends Node

# Reference to the plugin for EditorInterface access
var plugin: EditorPlugin = null

func _init(p_plugin) -> void:
    plugin = p_plugin

# Dispatch a request to the appropriate internal tool
func process_request(method: String, params: Dictionary) -> Dictionary:
    match method:
        "get_editor_state":
            return _get_editor_state()
        "get_scene_structure":
            return _get_scene_structure()
        "create_node":
            return _create_node(params)
        "edit_script":
            return _edit_script(params)
        "execute_editor_script":
            return _execute_editor_script(params)
        "delete_node":
            return _delete_node(params)
        "update_property":
            return _update_property(params)
        "read_script":
            return _read_script(params)
        _:
            return {"status": "error", "message": "Method not implemented in GAF-Handler."}

# --- TOOL IMPLEMENTATIONS (OPTIMIZED FOR GODOT 4.3+) ---

func _get_editor_state() -> Dictionary:
    var current_scene = EditorInterface.get_edited_scene_root()
    return {
        "status": "success",
        "scene_name": current_scene.name if current_scene else "No scene open",
        "scene_path": current_scene.scene_file_path if current_scene else "",
        "play_status": "Running" if EditorInterface.is_playing_scene() else "Stopped"
    }

func _get_scene_structure() -> Dictionary:
    var root = EditorInterface.get_edited_scene_root()
    if not root:
        return {"status": "error", "message": "No active scene to inspect."}
    
    return {
        "status": "success",
        "scene_tree": _node_to_dict(root)
    }

func _node_to_dict(node: Node) -> Dictionary:
    var dict = {
        "name": node.name,
        "type": node.get_class(),
        "children": []
    }
    for child in node.get_children():
        dict.children.append(_node_to_dict(child))
    return dict

func _create_node(params: Dictionary) -> Dictionary:
    var node_type = params.get("type", "Node")
    var node_name = params.get("name", "NewNode")
    var parent_path = params.get("parent", "")
    
    var root = EditorInterface.get_edited_scene_root()
    if not root:
        return {"status": "error", "message": "No active scene to create nodes in."}
        
    var new_node = ClassDB.instantiate(node_type)
    if not new_node:
        return {"status": "error", "message": "Invalid node type: " + node_type}
        
    new_node.name = node_name
    var parent = root.get_node(parent_path) if not parent_path.is_empty() else root
    parent.add_child(new_node)
    new_node.owner = root # Essential for persistence in the Editor
    
    return {"status": "success", "message": "Node created: " + node_name}

func _edit_script(params: Dictionary) -> Dictionary:
    var path = params.get("path", "")
    var content = params.get("content", "")
    
    if path.is_empty() or content.is_empty():
        return {"status": "error", "message": "Missing path or content for script edit."}
        
    var script = load(path)
    if not script or not script is GDScript:
        return {"status": "error", "message": "Could not load script at: " + path}
        
    script.source_code = content
    script.reload()
    
    return {"status": "success", "message": "Script updated and reloaded: " + path}

func _execute_editor_script(params: Dictionary) -> Dictionary:
    var code = params.get("code", "")
    if code.is_empty():
        return {"status": "error", "message": "No code provided for execution."}
        
    var script = GDScript.new()
    script.source_code = "@tool\nextends Node\nfunc execute(editor):\n" + code
    script.reload()
    
    var obj = script.new()
    obj.execute(plugin)
    obj.free()
    
    return {"status": "success", "message": "Editor script executed successfully."}

func _delete_node(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root:
        return {"status": "error", "message": "No active scene."}
    
    var target = root.get_node_or_null(node_path)
    if not target:
        return {"status": "error", "message": "Node not found: " + node_path}
    if target == root:
        return {"status": "error", "message": "Cannot delete scene root."}
        
    target.get_parent().remove_child(target)
    target.queue_free()
    return {"status": "success", "message": "Deleted node: " + node_path}

func _update_property(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var prop_name = params.get("property", "")
    var value = params.get("value")
    
    var root = EditorInterface.get_edited_scene_root()
    if not root:
        return {"status": "error", "message": "No active scene."}
        
    var target = root if node_path == "." else root.get_node_or_null(node_path)
    if not target:
        return {"status": "error", "message": "Node not found: " + node_path}
        
    target.set(prop_name, value)
    return {"status": "success", "message": "Updated " + prop_name + " on " + node_path}

func _read_script(params: Dictionary) -> Dictionary:
    var path = params.get("path", "")
    var script = load(path)
    if not script or not script is GDScript:
        return {"status": "error", "message": "Could not load GDScript at: " + path}
        
    return {"status": "success", "content": script.source_code}
