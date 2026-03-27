# GAF V1.4.0 - Development Roadmap

> ⚠️ **Internal Notes:** This file contains the current state and pending tasks for the Godot Agent Framework transition to a native MCP TCP bridge.

## 🎯 Current Status (Paused)
- **Cero Dependency achieved:** Removed `ws` and external SDK libraries.
- **MCP Standards compliant:** `initialize`, `tools/list`, and `tools/call` handshakes are perfectly running on port 1342 JSON-RPC 2.0 specs. Godot syncs perfectly inside the EditorPlugin.
- **Tools Inspired by `godot-mcp-pro`:** We've implemented initial core tools: `get_editor_state`, `get_scene_structure`, `create_node`, `edit_script`, `execute_editor_script`, `delete_node`, `update_property`, and `read_script`.

## 🛠️ Tasks for Next Session

1. **Verify MCP Connectivity:**
   - Launch `gaf_bridge.js` and connect an LLM client (Cursor / Claude Desktop) directly.
   - Force a `tools/list` ping and verify Godot processes the request cleanly without timeouts.

2. **Expand MCP Tool Library (Reference: `godot-mcp-pro`):**
   - Implement `duplicate_node`.
   - Implement `move_node` / reparenting logic.
   - Implement `connect_signal` and `disconnect_signal`.
   - Implement basic `get_open_scripts` mapping.

3. **Bi-Directional Event Signals (Phase 2):**
   - Currently, the AI polls state via `get_editor_state`, but Godot MCP should be able to broadcast notifications to the bridge when a user changes nodes or edits scripts.
   - Design JSON-RPC Notification standard for `window/showMessage` or custom broadcast so the AI knows when the context changed spontaneously.

4. **Repository Polish:**
   - Once the above is completed and tested in real projects, remove the WIP warning from `README.md`.
   - Update `agents/` prompt documentation so they know how to properly invoke the new expanded tools.
