# gaf_handler.gd
# 🏢 GODOT AGENT FRAMEWORK - SYNC ENGINE (GAF-SYNC) V1.4.0
# Translation layer between AI JSON requests and Godot Editor API.
# Implements Professional Command Pattern & UndoRedo Management.

@tool
extends Node

# Reference to the plugin for EditorInterface access
var plugin: EditorPlugin = null
var _tool_registry: Dictionary = {}

func _init(p_plugin) -> void:
    plugin = p_plugin
    _register_tools()

func _register_tools() -> void:
    # Patrón de registro dinámico de herramientas
    _tool_registry["get_editor_state"] = Callable(self, "_get_editor_state")
    _tool_registry["get_scene_structure"] = Callable(self, "_get_scene_structure")
    _tool_registry["create_node"] = Callable(self, "_create_node")
    _tool_registry["edit_script"] = Callable(self, "_edit_script")
    _tool_registry["execute_editor_script"] = Callable(self, "_execute_editor_script")
    _tool_registry["delete_node"] = Callable(self, "_delete_node")
    _tool_registry["update_property"] = Callable(self, "_update_property")
    _tool_registry["read_script"] = Callable(self, "_read_script")
    _tool_registry["duplicate_node"] = Callable(self, "_duplicate_node")
    _tool_registry["rename_node"] = Callable(self, "_rename_node")
    _tool_registry["reparent_node"] = Callable(self, "_reparent_node")
    _tool_registry["connect_signal"] = Callable(self, "_connect_signal")
    _tool_registry["disconnect_signal"] = Callable(self, "_disconnect_signal")
    _tool_registry["get_node_properties"] = Callable(self, "_get_node_properties")
    _tool_registry["instantiate_scene"] = Callable(self, "_instantiate_scene")
    _tool_registry["save_scene"] = Callable(self, "_save_scene")
    _tool_registry["open_scene"] = Callable(self, "_open_scene")
    _tool_registry["play_scene"] = Callable(self, "_play_scene")
    _tool_registry["stop_scene"] = Callable(self, "_stop_scene")
    _tool_registry["get_project_settings"] = Callable(self, "_get_project_settings")
    _tool_registry["search_files"] = Callable(self, "_search_files")
    _tool_registry["get_selected_nodes"] = Callable(self, "_get_selected_nodes")
    _tool_registry["set_selected_nodes"] = Callable(self, "_set_selected_nodes")
    _tool_registry["add_node_group"] = Callable(self, "_add_node_group")
    _tool_registry["remove_node_group"] = Callable(self, "_remove_node_group")

# Dispatch a request to the appropriate internal tool using Command Pattern
func process_request(method: String, params: Dictionary) -> Dictionary:
    if not _tool_registry.has(method):
        return {"status": "error", "message": "Method not implemented in GAF-Handler: " + method}
    
    var callable = _tool_registry[method]
    
    # Manejar métodos con y sin parámetros
    if method in ["get_editor_state", "get_scene_structure", "save_scene", "play_scene", "stop_scene", "get_selected_nodes"]:
        return callable.call()
    else:
        return callable.call(params)

# --- SMART TYPE PARSING PARA MUTACIÓN DE PROPIEDADES ---
func _smart_type_parse(raw_value: Variant) -> Variant:
    if typeof(raw_value) == TYPE_STRING:
        var text = raw_value.strip_edges()
        if text.begins_with("Vector2(") and text.ends_with(")"):
            var parts = text.substr(8, text.length() - 9).split(",")
            if parts.size() == 2: return Vector2(float(parts[0]), float(parts[1]))
        elif text.begins_with("Vector3(") and text.ends_with(")"):
            var parts = text.substr(8, text.length() - 9).split(",")
            if parts.size() == 3: return Vector3(float(parts[0]), float(parts[1]), float(parts[2]))
        elif text.begins_with("Color(") and text.ends_with(")"):
            var parts = text.substr(6, text.length() - 7).split(",")
            if parts.size() >= 3: 
                var a = float(parts[3]) if parts.size() == 4 else 1.0
                return Color(float(parts[0]), float(parts[1]), float(parts[2]), a)
    return raw_value

# --- TOOL IMPLEMENTATIONS ---

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
    
    var ur = plugin.get_undo_redo()
    ur.create_action("Create Node " + node_name)
    ur.add_do_method(parent, "add_child", new_node)
    ur.add_do_method(new_node, "set_owner", root)
    ur.add_undo_method(parent, "remove_child", new_node)
    ur.commit_action()
    
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
        
    var parent = target.get_parent()
    var ur = plugin.get_undo_redo()
    ur.create_action("Delete Node " + target.name)
    ur.add_do_method(parent, "remove_child", target)
    ur.add_undo_method(parent, "add_child", target)
    ur.add_undo_method(target, "set_owner", root)
    ur.commit_action()
    
    return {"status": "success", "message": "Deleted node: " + node_path}

func _update_property(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var prop_name = params.get("property", "")
    var raw_value = params.get("value")
    
    var root = EditorInterface.get_edited_scene_root()
    if not root:
        return {"status": "error", "message": "No active scene."}
        
    var target = root if node_path == "." else root.get_node_or_null(node_path)
    if not target:
        return {"status": "error", "message": "Node not found: " + node_path}
        
    var parsed_val = _smart_type_parse(raw_value)
    
    var ur = plugin.get_undo_redo()
    ur.create_action("Update Property " + prop_name)
    ur.add_do_property(target, prop_name, parsed_val)
    ur.add_undo_property(target, prop_name, target.get(prop_name))
    ur.commit_action()
    
    return {"status": "success", "message": "Updated " + prop_name + " on " + node_path}

func _read_script(params: Dictionary) -> Dictionary:
    var path = params.get("path", "")
    var script = load(path)
    if not script or not script is GDScript:
        return {"status": "error", "message": "Could not load GDScript at: " + path}
        
    return {"status": "success", "content": script.source_code}

func _duplicate_node(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root.get_node_or_null(node_path)
    if not target or target == root: return {"status": "error", "message": "Cannot duplicate node."}
    
    var dup = target.duplicate()
    var parent = target.get_parent()
    var ur = plugin.get_undo_redo()
    ur.create_action("Duplicate Node " + target.name)
    ur.add_do_method(parent, "add_child", dup)
    ur.add_do_method(dup, "set_owner", root)
    ur.add_undo_method(parent, "remove_child", dup)
    ur.commit_action()
    
    # Needs to recursively set_owner if children exist
    _recursive_set_owner(dup, root)
    return {"status": "success", "message": "Duplicated node as " + dup.name}

func _recursive_set_owner(node: Node, root: Node) -> void:
    for child in node.get_children():
        child.owner = root
        _recursive_set_owner(child, root)

func _rename_node(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var new_name = params.get("new_name", "Node")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root.get_node_or_null(node_path)
    if not target: return {"status": "error", "message": "Node not found."}
    
    var old_name = target.name
    var ur = plugin.get_undo_redo()
    ur.create_action("Rename Node " + old_name)
    ur.add_do_property(target, "name", new_name)
    ur.add_undo_property(target, "name", old_name)
    ur.commit_action()
    return {"status": "success", "message": "Renamed to " + new_name}

func _reparent_node(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var new_parent_path = params.get("new_parent_path", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root.get_node_or_null(node_path)
    var new_parent = root.get_node_or_null(new_parent_path) if new_parent_path != "" else root
    if not target or not new_parent: return {"status": "error", "message": "Node or parent not found."}
    
    var old_parent = target.get_parent()
    var ur = plugin.get_undo_redo()
    ur.create_action("Reparent Node " + target.name)
    ur.add_do_method(old_parent, "remove_child", target)
    ur.add_do_method(new_parent, "add_child", target)
    ur.add_do_method(target, "set_owner", root)
    ur.add_undo_method(new_parent, "remove_child", target)
    ur.add_undo_method(old_parent, "add_child", target)
    ur.add_undo_method(target, "set_owner", root)
    ur.commit_action()
    return {"status": "success", "message": "Reparented node."}

func _connect_signal(params: Dictionary) -> Dictionary:
    var spath = params.get("source_path", "")
    var sname = params.get("signal_name", "")
    var tpath = params.get("target_path", "")
    var mname = params.get("method_name", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var source = root.get_node_or_null(spath)
    var target = root.get_node_or_null(tpath)
    if not source or not target: return {"status": "error", "message": "Nodes not found."}
    
    var err = source.connect(sname, Callable(target, mname))
    if err == OK:
        return {"status": "success", "message": "Connected " + sname + " to " + mname}
    return {"status": "error", "message": "Failed to connect signal. Error code: " + str(err)}

func _disconnect_signal(params: Dictionary) -> Dictionary:
    var spath = params.get("source_path", "")
    var sname = params.get("signal_name", "")
    var tpath = params.get("target_path", "")
    var mname = params.get("method_name", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var source = root.get_node_or_null(spath)
    var target = root.get_node_or_null(tpath)
    if not source or not target: return {"status": "error", "message": "Nodes not found."}
    
    source.disconnect(sname, Callable(target, mname))
    return {"status": "success", "message": "Disconnected signal."}

func _get_node_properties(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root if node_path == "." else root.get_node_or_null(node_path)
    if not target: return {"status": "error", "message": "Node not found."}
    
    var props = {}
    for p in target.get_property_list():
        if p.usage & PROPERTY_USAGE_EDITOR:
            props[p.name] = str(target.get(p.name))
    return {"status": "success", "properties": props}

func _instantiate_scene(params: Dictionary) -> Dictionary:
    var parent_path = params.get("parent_path", "")
    var scene_path = params.get("scene_path", "")
    var instance_name = params.get("instance_name", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var parent = root.get_node_or_null(parent_path) if parent_path != "" else root
    if not parent: return {"status": "error", "message": "Parent not found."}
    
    var packed = load(scene_path)
    if not packed or not packed is PackedScene: return {"status": "error", "message": "Invalid packed scene."}
    
    var inst = packed.instantiate()
    if instance_name != "": inst.name = instance_name
    
    var ur = plugin.get_undo_redo()
    ur.create_action("Instantiate Scene")
    ur.add_do_method(parent, "add_child", inst)
    ur.add_do_method(inst, "set_owner", root)
    ur.add_undo_method(parent, "remove_child", inst)
    ur.commit_action()
    _recursive_set_owner(inst, root)
    return {"status": "success", "message": "Instantiated scene " + scene_path}

func _save_scene() -> Dictionary:
    EditorInterface.save_scene()
    return {"status": "success", "message": "Scene saved successfully."}

func _open_scene(params: Dictionary) -> Dictionary:
    var scene_path = params.get("scene_path", "")
    EditorInterface.open_scene_from_path(scene_path)
    return {"status": "success", "message": "Opened scene: " + scene_path}

func _play_scene() -> Dictionary:
    EditorInterface.play_current_scene()
    return {"status": "success", "message": "Scene playback started."}

func _stop_scene() -> Dictionary:
    EditorInterface.stop_playing_scene()
    return {"status": "success", "message": "Scene playback stopped."}

func _get_project_settings(params: Dictionary = {}) -> Dictionary:
    var property = params.get("property", "")
    if property != "":
        if ProjectSettings.has_setting(property):
            return {"status": "success", "property": property, "value": str(ProjectSettings.get_setting(property))}
        return {"status": "error", "message": "Setting not found."}
    
    var custom = []
    for prop in ProjectSettings.get_property_list():
        if prop.name.begins_with("application/") or prop.name.begins_with("autoload/"):
            custom.append({prop.name: str(ProjectSettings.get_setting(prop.name))})
    return {"status": "success", "settings": custom}

func _search_files(params: Dictionary) -> Dictionary:
    var ext = params.get("extension", "")
    var query = params.get("query", "")
    var results = []
    _recursive_search_files("res://", ext, query, results, 0, 100)
    
    if results.size() >= 100:
        return {"status": "success", "files": results, "warning": "Limiting results to 100 to prevent editor freezing."}
    return {"status": "success", "files": results}

func _recursive_search_files(path: String, ext: String, query: String, results: Array, depth: int, max_results: int) -> void:
    # Cap de seguridad: Profundidad máxima 5 o si ya tenemos bastantes resultados
    if depth > 5 or results.size() >= max_results:
        return
        
    var dir = DirAccess.open(path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            # Cortafuegos anti-freeze
            if results.size() >= max_results:
                break
                
            if dir.current_is_dir() and not file_name.begins_with("."):
                _recursive_search_files(path + file_name + "/", ext, query, results, depth + 1, max_results)
            elif not dir.current_is_dir() and not file_name.begins_with("."):
                var match = true
                if ext != "" and not file_name.ends_with(ext): match = false
                if query != "" and query.to_lower() not in file_name.to_lower(): match = false
                if match:
                    results.append(path + file_name)
                    
            file_name = dir.get_next()

func _get_selected_nodes() -> Dictionary:
    var selected = EditorInterface.get_selection().get_selected_nodes()
    var paths = []
    var root = EditorInterface.get_edited_scene_root()
    for node in selected:
        if root: 
            var path = root.get_path_to(node)
            paths.append(str(path) if not path.is_empty() else ".")
    return {"status": "success", "selected_nodes": paths}

func _set_selected_nodes(params: Dictionary) -> Dictionary:
    var paths = params.get("paths", [])
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    
    var selection = EditorInterface.get_selection()
    selection.clear()
    
    for path in paths:
        var target = root if path == "." else root.get_node_or_null(path)
        if target: selection.add_node(target)
        
    return {"status": "success", "message": "Selection updated."}

func _add_node_group(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var group_name = params.get("group_name", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root if node_path == "." else root.get_node_or_null(node_path)
    if not target: return {"status": "error", "message": "Node not found."}
    
    target.add_to_group(group_name, true) # persistent
    return {"status": "success", "message": "Added to group."}

func _remove_node_group(params: Dictionary) -> Dictionary:
    var node_path = params.get("path", "")
    var group_name = params.get("group_name", "")
    var root = EditorInterface.get_edited_scene_root()
    if not root: return {"status": "error", "message": "No active scene."}
    var target = root if node_path == "." else root.get_node_or_null(node_path)
    if not target: return {"status": "error", "message": "Node not found."}
    
    target.remove_from_group(group_name)
    return {"status": "success", "message": "Removed from group."}
