# 🤖 GAF MCP TOOLING GUIDE (For AI Agents)

> [!IMPORTANT]
> **READ BEFORE EXECUTING:** This guide dictates exactly HOW and WHEN an AI Agent must use the Godot Agent Framework (GAF) Model Context Protocol tools. If you are an AI reading this, you are bound by these rules.

## 1. Safety & Introspection First (The Golden Rule)
**NEVER** guess a file path (`res://scripts/player.gd`) or a Node Path (`/root/Main/Player`). You will fail.
Before making any mutations, you MUST establish context:
- Use `search_files` to find the exact absolute `res://` path of the script or scene you need.
- Use `get_scene_structure` (or `get_selected_nodes` if the user is pointing at something) to understand the exact hierarchy of the active scene.

## 2. Editor-First Manipulation (Zero-Code Prototyping)
Do not immediately jump to writing GDScript to solve a visual or structural problem. GAF gives you native Godot Editor access.
- **Modifying Properties:** If the user says "Make the player red and twice as big", **DO NOT** write a script in `_ready()` to do this. Use the `update_property` MCP tool to change the `modulate` and `scale` properties natively in the Editor.
- **Wiring Logic:** If the user says "Make the button reset the level", **DO NOT** write a complex signal manager script. Use the `connect_signal` MCP tool to wire `pressed` from the Button directly to the target node's reset method.

## 3. The Undo/Redo Safeguard
All node creation (`create_node`), deletion (`delete_node`), property updates (`update_property`), and reparenting (`reparent_node`) are wrapped in Godot's `EditorUndoRedoManager`. 
- **Execute Freely:** You do not need to ask the user for permission to try structural changes. If you break the scene layout, the user can just press `Ctrl + Z` in Godot to revert your MCP tool call.
- **Scripts are NOT Undoable:** Modifications to `.gd` files via `edit_script` or `write_to_file` are written to disk. Be highly precise.

## 4. Complex Data Types (Smart Parsing)
When using tools like `update_property` or `create_node`, you will often need to send Godot-specific data types through the JSON-RPC tunnel.
- GAF features a Smart Type Parser. Just send the value as a formatted string!
- **Position/Scale:** Send `"Vector2(100, 50)"` or `"Vector3(0, 10, 0)"`.
- **Colors:** Send `"Color(1, 0, 0, 1)"` (Red).
- **Booleans/Ints:** Send standard JSON `true`, `false`, `1`, `0.5`.

## 5. Focus & Presentation
When you synthesize a new UI element or add a new component to an Enemy, the user might not see it if their Godot camera is pointing elsewhere in a massive level.
- ALWAYS end your visual workflow by calling `set_selected_nodes` with the path of the node you just modified. This forces the Godot Editor to highlight it for the user.

## 6. Live Testing (QA Validation)
If you are unsure whether a math formula or API call works in Godot 4:
- Do not write it into a core gameplay script and "hope" it works.
- Use `execute_editor_script` to run an isolated `@tool` script block directly inside the Godot Editor thread and parse the returned variables.

## Example Workflow (Creating a Hazard):
1. User: *"Create a fire trap in the current scene that hurts the player."*
2. **AI Action:** `get_scene_structure` -> Finds `/root/Level/Hazards`.
3. **AI Action:** `create_node` -> Creates an `Area3D` under `/root/Level/Hazards` named `FireTrap`.
4. **AI Action:** `create_node` -> Creates a `CollisionShape3D` under the trap.
5. **AI Action:** `update_property` -> Sets the collision shape's size.
6. **AI Action:** `connect_signal` -> Wires `body_entered` to a damage script.
7. **AI Action:** `set_selected_nodes` -> Selects `/root/Level/Hazards/FireTrap` so the user can inspect it.
8. **AI Action:** Respond to user: *"The FireTrap has been created and selected in your editor!"*
