# 🤖 Godot Agent Framework (GAF) - V1.5.0

![Godot Engine](https://img.shields.io/badge/Godot-4.3+-blue?logo=godot-engine&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Native_Bridge-green?logo=node.js)
![MCP](https://img.shields.io/badge/Protocol-MCP_JSON--RPC-orange)

The **Godot Agent Framework (GAF)** is a high-performance, secure, and fully-featured ecosystem designed to empower AI Agents (like Claude, Gemini, GPT-4) in autonomous game development. It establishes a robust bi-directional communication channel between AI models and the Godot Editor API, enabling real-time scene manipulation, script editing, and deep project lifecycle management using the official **Model Context Protocol (MCP)**.

---

## 🚀 How to Start (For Humans)

Welcome to the future of game development. If you want your AI assistant to start coding and building scenes for you, follow these simple steps:

1. **Clone this repository** into your workspace:
   ```bash
   git clone https://github.com/JXUE0/Godot-Agent-Framework.git
   ```

2. **Open a chat with your AI Assistant** (in Cursor, Cline, or Antigravity) inside your Godot project workspace.
   
3. **Tell the AI:** *"Start GAF"* or *"Ejecuta GAF"*.
   > **Magic Step:** Our built-in `.clinerules` and `.cursorrules` will force the AI to automatically detect if the framework is missing in your game. It will proactively offer to install it using the `setup_project.ps1` script and launch the Node.js bridge for you!

4. **Enable the Plugin:** Open your Godot 4.3+ project, go to `Project > Project Settings > Plugins`, and check the enable box for **"GAF-Sync Engine"**.

5. **Start Creating!** Tell the AI: *"Create a Player scene with a CharacterBody2D and a Sprite"* or *"Build me a farming system grid"* and watch the Editor update in real-time.

---

## 📂 Framework Structure (Inside your Godot Project)

Once cloned inside your Godot project (or placed alongside it) and installed successfully via the setup script, your directory structure should look exactly like a standard Godot repository but Supercharged with AI components:

```text
Your-Godot-Game-Project/
├── addons/
│   └── gaf_sync/           # 🔌 The Godot Addon: Injected dynamically by the setup script (Do NOT edit manually).
├── Godot-Agent-Framework/  # 📦 The Framework Monorepo (You clone this here):
│   ├── agents/             # 🧠 The "Brains": Specialized AI personas (Producer, QA, Tech Artist, Lead Dev).
│   ├── docs/               # 📜 Rules of the Engine: The MCP best practices manual.
│   ├── scripts/            # ⚙️ Deployment: Auto-installers like `setup_project.ps1`.
│   ├── tools/mcp/          # 🌉 The Bridge: The Node.js native TCP server (`gaf_bridge.js`).
│   ├── .clinerules         # 🛡️ AI Warden: Core rules that force Cline/Roo to use the framework properly.
│   └── .cursorrules        # 🛡️ AI Warden: Rules tailored for Cursor IDE.
├── .godot/                 # Godot Cache (Ignored).
├── project.godot           # Your Godot Engine configuration.
└── [Your Godot Scenes & Scripts...]
```

---

## 💡 Pro Tips for GitHub & Workflow

- **The `Undo` safety net:** All AI actions that modify the SceneTree are wrapped in native Godot `UndoRedo` operations. If the AI messes up a node hierarchy, just click on the Godot Editor and press `Ctrl + Z`!
- **Version Control is King:** Always commit your Godot project to Git **before** asking the AI to do a massive architectural refactoring. `git add . && git commit -m "pre-ai-work"`.
- **Agents Roles:** Try talking to the AI specifically. For example: *"Read your Technical Artist agent profile and fix my UI anchors"*. The Framework is built to respect these roles.
- **No NPM bloat:** The Node.js bridge (`tools/mcp/gaf_bridge.js`) uses zero external dependencies. It's built entirely on native modules. This means no annoying `npm install` requirements.

---

## 🛠️ Tool Arsenal (19+ Native Editor Tools)

The AI Agent has unparalleled access to your Godot runtime through the following tool categories:

### 1. FileSystem & Project Introspection
- `get_project_settings`: Reads `project.godot` configuration and autoloads.
- `search_files`: Deep searches `res://` for files by name or extension (protected against infinite loops).
- `read_script` & `edit_script`: Reads and overwrites GDScript content with instant hot-reloading.

### 2. Scene & Hierarchy Manipulation 
- `create_node`, `delete_node`, `duplicate_node`, `rename_node`, `reparent_node`: Full structural control over the active scene tree.
- `instantiate_scene`: Drops saved `.tscn` prefabs directly into your current level.

### 3. Editor UX & Selection
- `get_selected_nodes`: Allows the AI to know exactly what node you are currently clicking on.
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

---

## 📡 Advanced Protocol Primitives (MCP)

GAF fully supports passive **Resources** and **Prompts** to automatically feed context to the AI before tasks begin:

- **Resources (RAG):** Automatically exposes `godot://project_settings/autoloads` and `godot://input/actions` so the AI understands your Input Map without asking.
- **Prompts:** Includes built-in workflows like `generate_ai_statemachine` and `analyze_ubershader_performance` to kickstart complex, studio-standard tasks instantly.

---

### 📜 Licensing
Godot Agent Framework (GAF) is released under the **MIT License**.

This is a 100% original, open-source tool built from the ground up to bring professional AI pair-programming to the Godot ecosystem. You are free to use it, modify it, and distribute it in your own projects, provided you include the original copyright notice as detailed in the `LICENSE` file.
