# Godot Agent Framework (GAF) - V1.5.0

The **Godot Agent Framework (GAF)** is a high-performance, secure, and fully-featured ecosystem designed to empower AI Agents in autonomous game development. It establishes a robust bi-directional communication channel between AI models and the Godot Editor API, enabling real-time scene manipulation, script editing, and deep project lifecycle management using the official **Model Context Protocol (MCP)**.

## 🌟 Key Features (V1.5.0 Architecture)

Following industry standards, GAF implements an advanced `MCPProtocolRouter` pattern, providing the ultimate pair-programming experience in Godot 4.3+:

- **19+ Native Editor Tools:** Full control over Godot's SceneTree, FileSystem, and Inspector via AI.
- **EditorUndoRedoManager Support:** Destructive actions (like modifying or deleting nodes) are wrapped in native Godot Undo/Redo actions. You can always press `Ctrl + Z` if the AI makes a mistake!
- **Smart Type Parsing:** The AI can send strings like `"Vector3(1, 2, 0)"` or `"Color(1, 0, 0)"`, and GAF will intelligently cast them into actual Godot mathematical objects to prevent crashes.
- **Zero-Dependency TCP Bridge:** A pure Node.js gateway ensuring lightning-fast local execution on port `1342` without the need for external `npm` packages.
- **Continuous Safety:** Deep safety checks against infinite loops when scanning the filesystem, bypassing hidden directories (like `.godot/`) to prevent editor freezing.

## 🛠️ Tool Arsenal

The AI Agent has unparalleled access to your Godot runtime through the following tool categories:

### 1. FileSystem & Project Introspection
- `get_project_settings`: Reads `project.godot` configuration and autoloads.
- `search_files`: Deep searches `res://` for files by name or extension (protected against infinite loops).
- `read_script` & `edit_script`: Reads and overwrites GDScript content with instant hot-reloading.

### 2. Scene & Hierarchy Manipulation 
- `create_node`, `delete_node`, `duplicate_node`, `rename_node`, `reparent_node`: Full structural control over the active scene tree.
- `instantiate_scene`: Drops saved `.tscn` prefabs directly into your current level.

### 3. Editor UX & Selection
- `get_selected_nodes`: Allows the AI to know exactly what node you are currently clicking on!
- `set_selected_nodes`: The AI can change your Editor's focus to show you what it just modified.

### 4. Logic & Metadata
- `update_property`: Modifies any node parameter (Scale, Opacity, Text) in real-time.
- `get_node_properties`: Introspects deeply into a specific node's available configuration.
- `connect_signal` / `disconnect_signal`: Wires logic dynamically between nodes without touching code.
- `add_node_group` / `remove_node_group`: Organizes project entities seamlessly.

### 5. Telemetry & Execution
- `get_editor_state` / `get_scene_structure`: Passive context gathering for the agent.
- `execute_editor_script`: Runs arbitrary `@tool` GDScript macros inside the editor thread.
- `save_scene`, `play_scene`, `stop_scene`: Controls the game's testing lifecycle.

## 📡 Advanced Protocol Primitives (MCP)

GAF fully supports passive **Resources** and **Prompts** to automatically feed context to the AI before tasks begin:

- **Resources (RAG):** Automatically exposes `godot://project_settings/autoloads` and `godot://input/actions` so the AI understands your Input Map without asking.
- **Prompts:** Includes built-in workflows like `generate_ai_statemachine` and `analyze_ubershader_performance` to kickstart complex, studio-standard tasks instantly.

## 🚀 Quick Deployment Guide

To deploy GAF in your development environment:

1. **Initialize Project:**
   ```powershell
   powershell -File "scripts/setup_project.ps1" -ProjectRoot "C:/YourProject" -InstallMCP
   ```
2. **Launch GAF-Bridge:**
   ```bash
   node tools/mcp/gaf_bridge.js
   ```
3. **Connect Editor:**
   Open Godot 4.3+, navigate to `Project Settings > Plugins`, and enable **"GAF-Sync Engine"**.

---

### Licensing
GAF is built for high-level engineering environments. It is a derivative work evolved from Solomon Elias's **godot-mcp**. Full legal and third-party details are documented in `THIRD_PARTY_NOTICES.md`.
