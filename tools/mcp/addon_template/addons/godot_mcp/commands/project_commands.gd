@tool
class_name MCPProjectCommands
extends MCPBaseCommandProcessor

const DEFAULT_MAX_RESULTS := 2000
const DEFAULT_MAX_DEPTH := 12
const DEFAULT_MAX_TEXT_MATCHES := 200
const DEFAULT_MAX_MATCHES_PER_FILE := 20
const DEFAULT_MAX_FILE_SIZE_BYTES := 512 * 1024
const DEFAULT_MAX_READ_BYTES := 256 * 1024
const DEFAULT_EXCLUDED_DIRS := [
	".git",
	".godot",
	".import",
	"node_modules",
	"bin",
	"obj"
]

func process_command(client_id: int, command_type: String, params: Dictionary, command_id: String) -> bool:
	match command_type:
		"get_project_info":
			_get_project_info(client_id, params, command_id)
			return true
		"list_project_files":
			_list_project_files(client_id, params, command_id)
			return true
		"get_project_structure":
			_get_project_structure(client_id, params, command_id)
			return true
		"get_project_settings":
			_get_project_settings(client_id, params, command_id)
			return true
		"list_project_resources":
			_list_project_resources(client_id, params, command_id)
			return true
		"search_project_files":
			_search_project_files(client_id, params, command_id)
			return true
		"search_text_in_files":
			_search_text_in_files(client_id, params, command_id)
			return true
		"read_project_file":
			_read_project_file(client_id, params, command_id)
			return true
	return false  # Command not handled

func _get_project_info(client_id: int, _params: Dictionary, command_id: String) -> void:
	var project_name = ProjectSettings.get_setting("application/config/name", "Untitled Project")
	var project_version = ProjectSettings.get_setting("application/config/version", "1.0.0")
	var project_path = ProjectSettings.globalize_path("res://")
	
	# Get Godot version info and structure it as expected by the server
	var version_info = Engine.get_version_info()
	print("Raw Godot version info: ", version_info)
	
	# Create structured version object with the expected properties
	var structured_version = {
		"major": version_info.get("major", 0),
		"minor": version_info.get("minor", 0),
		"patch": version_info.get("patch", 0)
	}
	
	_send_success(client_id, {
		"project_name": project_name,
		"project_version": project_version,
		"project_path": project_path,
		"godot_version": structured_version,
		"current_scene": get_tree().edited_scene_root.scene_file_path if get_tree().edited_scene_root else ""
	}, command_id)

func _list_project_files(client_id: int, params: Dictionary, command_id: String) -> void:
	var extensions = _normalize_extensions(params.get("extensions", []))
	var max_results = clamp(int(params.get("max_results", DEFAULT_MAX_RESULTS)), 1, 20000)
	var max_depth = clamp(int(params.get("max_depth", DEFAULT_MAX_DEPTH)), 1, 64)
	var include_hidden = bool(params.get("include_hidden", false))
	var excluded_dirs = _build_excluded_dir_set(params.get("exclude_dirs", DEFAULT_EXCLUDED_DIRS))
	var files = []
	var stats = {
		"visited_dirs": 0,
		"visited_files": 0,
		"truncated": false
	}

	# Bounded recursive scan to avoid editor stalls on large projects.
	_scan_directory_limited(
		"",
		extensions,
		files,
		max_results,
		max_depth,
		0,
		excluded_dirs,
		include_hidden,
		stats
	)
	
	_send_success(client_id, {
		"files": files,
		"truncated": stats["truncated"],
		"max_results": max_results,
		"max_depth": max_depth,
		"visited_dirs": stats["visited_dirs"],
		"visited_files": stats["visited_files"]
	}, command_id)

func _scan_directory_limited(path: String, extensions: Array, files: Array, max_results: int, max_depth: int, depth: int, excluded_dirs: Dictionary, include_hidden: bool, stats: Dictionary) -> void:
	if files.size() >= max_results:
		stats["truncated"] = true
		return

	if depth > max_depth:
		return

	var dir = DirAccess.open("res://" + path)
	if not dir:
		return

	stats["visited_dirs"] += 1
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		if not include_hidden and file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			if excluded_dirs.has(file_name):
				file_name = dir.get_next()
				continue

			_scan_directory_limited(
				path + file_name + "/",
				extensions,
				files,
				max_results,
				max_depth,
				depth + 1,
				excluded_dirs,
				include_hidden,
				stats
			)
		else:
			stats["visited_files"] += 1
			var file_path = path + file_name
			if _matches_extensions(file_name, extensions):
				files.append("res://" + file_path)

				if files.size() >= max_results:
					stats["truncated"] = true
					break
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _matches_extensions(file_name: String, extensions: Array) -> bool:
	if extensions.is_empty():
		return true

	var lowered_name = file_name.to_lower()
	for ext in extensions:
		if lowered_name.ends_with(str(ext).to_lower()):
			return true

	return false

func _normalize_extensions(raw_extensions: Variant) -> Array:
	var result: Array = []

	if raw_extensions is Array:
		for ext in raw_extensions:
			var ext_str = str(ext).strip_edges()
			if ext_str.is_empty():
				continue
			if not ext_str.begins_with("."):
				ext_str = "." + ext_str
			result.append(ext_str.to_lower())

	return result

func _build_excluded_dir_set(raw_excluded_dirs: Variant) -> Dictionary:
	var excluded := {}
	if raw_excluded_dirs is Array:
		for dir_name in raw_excluded_dirs:
			var normalized = str(dir_name).strip_edges()
			if normalized.is_empty():
				continue
			excluded[normalized] = true

	return excluded

func _get_project_structure(client_id: int, params: Dictionary, command_id: String) -> void:
	var max_depth = clamp(int(params.get("max_depth", 10)), 1, 64)
	var include_hidden = bool(params.get("include_hidden", false))
	var excluded_dirs = _build_excluded_dir_set(params.get("exclude_dirs", DEFAULT_EXCLUDED_DIRS))
	var structure = {
		"directories": [],
		"file_counts": {},
		"total_files": 0,
		"max_depth": max_depth
	}
	
	var dir = DirAccess.open("res://")
	if dir:
		_analyze_project_structure(dir, "", structure, 0, max_depth, excluded_dirs, include_hidden)
	else:
		return _send_error(client_id, "Failed to open res:// directory", command_id)
	
	_send_success(client_id, structure, command_id)

func _analyze_project_structure(dir: DirAccess, path: String, structure: Dictionary, depth: int, max_depth: int, excluded_dirs: Dictionary, include_hidden: bool) -> void:
	if depth > max_depth:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		if not include_hidden and file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			if excluded_dirs.has(file_name):
				file_name = dir.get_next()
				continue

			var dir_path = path + file_name + "/"
			structure["directories"].append("res://" + dir_path)
			
			var subdir = DirAccess.open("res://" + dir_path)
			if subdir:
				_analyze_project_structure(subdir, dir_path, structure, depth + 1, max_depth, excluded_dirs, include_hidden)
		else:
			structure["total_files"] += 1
			
			var extension = file_name.get_extension()
			if extension in structure["file_counts"]:
				structure["file_counts"][extension] += 1
			else:
				structure["file_counts"][extension] = 1
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _get_project_settings(client_id: int, params: Dictionary, command_id: String) -> void:
	# Get relevant project settings
	var settings = {
		"project_name": ProjectSettings.get_setting("application/config/name", "Untitled Project"),
		"project_version": ProjectSettings.get_setting("application/config/version", "1.0.0"),
		"display": {
			"width": ProjectSettings.get_setting("display/window/size/viewport_width", 1024),
			"height": ProjectSettings.get_setting("display/window/size/viewport_height", 600),
			"mode": ProjectSettings.get_setting("display/window/size/mode", 0),
			"resizable": ProjectSettings.get_setting("display/window/size/resizable", true)
		},
		"physics": {
			"2d": {
				"default_gravity": ProjectSettings.get_setting("physics/2d/default_gravity", 980)
			},
			"3d": {
				"default_gravity": ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
			}
		},
		"rendering": {
			"quality": {
				"msaa": ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_2d", 0)
			}
		},
		"input_map": {}
	}
	
	# Get input mappings
	var input_map = ProjectSettings.get_setting("input")
	if input_map:
		settings["input_map"] = input_map
	
	_send_success(client_id, settings, command_id)

func _list_project_resources(client_id: int, params: Dictionary, command_id: String) -> void:
	var max_depth = clamp(int(params.get("max_depth", 10)), 1, 64)
	var include_hidden = bool(params.get("include_hidden", false))
	var excluded_dirs = _build_excluded_dir_set(params.get("exclude_dirs", DEFAULT_EXCLUDED_DIRS))
	var resources = {
		"scenes": [],
		"scripts": [],
		"textures": [],
		"audio": [],
		"models": [],
		"resources": [],
		"max_depth": max_depth
	}
	
	var dir = DirAccess.open("res://")
	if dir:
		_scan_resources(dir, "", resources, 0, max_depth, excluded_dirs, include_hidden)
	else:
		return _send_error(client_id, "Failed to open res:// directory", command_id)
	
	_send_success(client_id, resources, command_id)

func _search_project_files(client_id: int, params: Dictionary, command_id: String) -> void:
	var query = str(params.get("query", "")).strip_edges()
	if query.is_empty():
		return _send_error(client_id, "Search query cannot be empty", command_id)

	var extensions = _normalize_extensions(params.get("extensions", []))
	var max_results = clamp(int(params.get("max_results", DEFAULT_MAX_RESULTS)), 1, 20000)
	var max_depth = clamp(int(params.get("max_depth", DEFAULT_MAX_DEPTH)), 1, 64)
	var include_hidden = bool(params.get("include_hidden", false))
	var case_sensitive = bool(params.get("case_sensitive", false))
	var excluded_dirs = _build_excluded_dir_set(params.get("exclude_dirs", DEFAULT_EXCLUDED_DIRS))
	var results = []
	var stats = {
		"visited_dirs": 0,
		"visited_files": 0,
		"truncated": false
	}

	var normalized_query = query if case_sensitive else query.to_lower()
	_search_files_by_name(
		"",
		normalized_query,
		case_sensitive,
		extensions,
		results,
		max_results,
		max_depth,
		0,
		excluded_dirs,
		include_hidden,
		stats
	)

	_send_success(client_id, {
		"query": query,
		"matches": results,
		"count": results.size(),
		"truncated": stats["truncated"],
		"visited_dirs": stats["visited_dirs"],
		"visited_files": stats["visited_files"],
		"max_results": max_results,
		"max_depth": max_depth
	}, command_id)

func _search_text_in_files(client_id: int, params: Dictionary, command_id: String) -> void:
	var query = str(params.get("query", "")).strip_edges()
	if query.is_empty():
		return _send_error(client_id, "Text search query cannot be empty", command_id)

	var extensions = _normalize_extensions(params.get("extensions", [".gd", ".tscn", ".tres", ".cfg", ".md", ".txt"]))
	var max_results = clamp(int(params.get("max_results", DEFAULT_MAX_TEXT_MATCHES)), 1, 5000)
	var max_depth = clamp(int(params.get("max_depth", DEFAULT_MAX_DEPTH)), 1, 64)
	var max_matches_per_file = clamp(int(params.get("max_matches_per_file", DEFAULT_MAX_MATCHES_PER_FILE)), 1, 200)
	var max_file_size_bytes = clamp(int(params.get("max_file_size_bytes", DEFAULT_MAX_FILE_SIZE_BYTES)), 1024, 10 * 1024 * 1024)
	var context_chars = clamp(int(params.get("context_chars", 80)), 10, 300)
	var include_hidden = bool(params.get("include_hidden", false))
	var case_sensitive = bool(params.get("case_sensitive", false))
	var excluded_dirs = _build_excluded_dir_set(params.get("exclude_dirs", DEFAULT_EXCLUDED_DIRS))
	var matches = []
	var stats = {
		"visited_dirs": 0,
		"visited_files": 0,
		"scanned_files": 0,
		"skipped_large_files": 0,
		"truncated": false
	}

	_search_text_recursive(
		"",
		query,
		case_sensitive,
		extensions,
		matches,
		max_results,
		max_depth,
		0,
		max_matches_per_file,
		max_file_size_bytes,
		context_chars,
		excluded_dirs,
		include_hidden,
		stats
	)

	_send_success(client_id, {
		"query": query,
		"matches": matches,
		"count": matches.size(),
		"truncated": stats["truncated"],
		"visited_dirs": stats["visited_dirs"],
		"visited_files": stats["visited_files"],
		"scanned_files": stats["scanned_files"],
		"skipped_large_files": stats["skipped_large_files"],
		"max_results": max_results,
		"max_depth": max_depth
	}, command_id)

func _read_project_file(client_id: int, params: Dictionary, command_id: String) -> void:
	var path = str(params.get("path", "")).strip_edges()
	if path.is_empty():
		return _send_error(client_id, "Path cannot be empty", command_id)

	if not path.begins_with("res://"):
		path = "res://" + path

	if not FileAccess.file_exists(path):
		return _send_error(client_id, "File not found: %s" % path, command_id)

	var max_bytes = clamp(int(params.get("max_bytes", DEFAULT_MAX_READ_BYTES)), 1024, 4 * 1024 * 1024)
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _send_error(client_id, "Failed to open file: %s" % path, command_id)

	var file_size = int(file.get_length())
	var read_size = min(file_size, max_bytes)
	var content_bytes = file.get_buffer(read_size)
	var truncated = file_size > max_bytes

	_send_success(client_id, {
		"path": path,
		"size_bytes": file_size,
		"read_bytes": read_size,
		"truncated": truncated,
		"content": content_bytes.get_string_from_utf8()
	}, command_id)

func _scan_resources(dir: DirAccess, path: String, resources: Dictionary, depth: int, max_depth: int, excluded_dirs: Dictionary, include_hidden: bool) -> void:
	if depth > max_depth:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		if not include_hidden and file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			if excluded_dirs.has(file_name):
				file_name = dir.get_next()
				continue

			var subdir = DirAccess.open("res://" + path + file_name)
			if subdir:
				_scan_resources(subdir, path + file_name + "/", resources, depth + 1, max_depth, excluded_dirs, include_hidden)
		else:
			var file_path = "res://" + path + file_name
			
			# Categorize by extension
			if file_name.ends_with(".tscn") or file_name.ends_with(".scn"):
				resources["scenes"].append(file_path)
			elif file_name.ends_with(".gd") or file_name.ends_with(".cs"):
				resources["scripts"].append(file_path)
			elif file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".jpeg"):
				resources["textures"].append(file_path)
			elif file_name.ends_with(".wav") or file_name.ends_with(".ogg") or file_name.ends_with(".mp3"):
				resources["audio"].append(file_path)
			elif file_name.ends_with(".obj") or file_name.ends_with(".glb") or file_name.ends_with(".gltf"):
				resources["models"].append(file_path)
			elif file_name.ends_with(".tres") or file_name.ends_with(".res"):
				resources["resources"].append(file_path)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _search_files_by_name(path: String, normalized_query: String, case_sensitive: bool, extensions: Array, results: Array, max_results: int, max_depth: int, depth: int, excluded_dirs: Dictionary, include_hidden: bool, stats: Dictionary) -> void:
	if results.size() >= max_results:
		stats["truncated"] = true
		return

	if depth > max_depth:
		return

	var dir = DirAccess.open("res://" + path)
	if not dir:
		return

	stats["visited_dirs"] += 1
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		if not include_hidden and file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			if excluded_dirs.has(file_name):
				file_name = dir.get_next()
				continue

			_search_files_by_name(
				path + file_name + "/",
				normalized_query,
				case_sensitive,
				extensions,
				results,
				max_results,
				max_depth,
				depth + 1,
				excluded_dirs,
				include_hidden,
				stats
			)
		else:
			stats["visited_files"] += 1
			if _matches_extensions(file_name, extensions):
				var file_name_cmp = file_name if case_sensitive else file_name.to_lower()
				if file_name_cmp.find(normalized_query) != -1:
					results.append("res://" + path + file_name)
					if results.size() >= max_results:
						stats["truncated"] = true
						break

		file_name = dir.get_next()

	dir.list_dir_end()

func _search_text_recursive(path: String, query: String, case_sensitive: bool, extensions: Array, matches: Array, max_results: int, max_depth: int, depth: int, max_matches_per_file: int, max_file_size_bytes: int, context_chars: int, excluded_dirs: Dictionary, include_hidden: bool, stats: Dictionary) -> void:
	if matches.size() >= max_results:
		stats["truncated"] = true
		return

	if depth > max_depth:
		return

	var dir = DirAccess.open("res://" + path)
	if not dir:
		return

	stats["visited_dirs"] += 1
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		if not include_hidden and file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			if excluded_dirs.has(file_name):
				file_name = dir.get_next()
				continue

			_search_text_recursive(
				path + file_name + "/",
				query,
				case_sensitive,
				extensions,
				matches,
				max_results,
				max_depth,
				depth + 1,
				max_matches_per_file,
				max_file_size_bytes,
				context_chars,
				excluded_dirs,
				include_hidden,
				stats
			)
		else:
			stats["visited_files"] += 1
			if _matches_extensions(file_name, extensions):
				_scan_file_for_text(
					"res://" + path + file_name,
					query,
					case_sensitive,
					matches,
					max_results,
					max_matches_per_file,
					max_file_size_bytes,
					context_chars,
					stats
				)

		if matches.size() >= max_results:
			stats["truncated"] = true
			break

		file_name = dir.get_next()

	dir.list_dir_end()

func _scan_file_for_text(file_path: String, query: String, case_sensitive: bool, matches: Array, max_results: int, max_matches_per_file: int, max_file_size_bytes: int, context_chars: int, stats: Dictionary) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return

	var file_size = int(file.get_length())
	if file_size > max_file_size_bytes:
		stats["skipped_large_files"] += 1
		file = null
		return

	stats["scanned_files"] += 1
	var line_number = 0
	var matches_in_file = 0
	var query_cmp = query if case_sensitive else query.to_lower()

	while not file.eof_reached():
		if matches.size() >= max_results or matches_in_file >= max_matches_per_file:
			break

		var line = file.get_line()
		line_number += 1

		var line_cmp = line if case_sensitive else line.to_lower()
		var start_index = 0
		while true:
			var pos = line_cmp.find(query_cmp, start_index)
			if pos == -1:
				break

			var snippet_start = maxi(0, pos - context_chars)
			var snippet_len = mini(line.length() - snippet_start, query.length() + (context_chars * 2))
			var snippet = line.substr(snippet_start, snippet_len)

			matches.append({
				"path": file_path,
				"line": line_number,
				"column": pos + 1,
				"snippet": snippet
			})

			matches_in_file += 1
			if matches.size() >= max_results or matches_in_file >= max_matches_per_file:
				break

			start_index = pos + maxi(1, query.length())

		if matches.size() >= max_results or matches_in_file >= max_matches_per_file:
			break

	file = null
