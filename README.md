# 🤖 Godot Agent Framework (GAF) - V1.5.0

![Godot Engine](https://img.shields.io/badge/Godot-4.3+-blue?logo=godot-engine&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Native_Bridge-green?logo=node.js)
![MCP](https://img.shields.io/badge/Protocol-MCP_JSON--RPC-orange)

[Español (Spanish)](docs/es/README.md)

---

The **Godot Agent Framework (GAF)** is a high-performance, secure, and fully-featured ecosystem designed to empower AI Agents in autonomous game development. It establishes a robust bi-directional communication channel between AI models and the Godot Editor API.

## 📡 MCP Installation & Config

To enable the AI to use these tools, you must register the **GAF-Sync Bridge** in your AI IDE settings.

### 1. Cursor IDE
- Go to `Settings > Cursor Settings > MCP`.
- Add a new MCP Server:
  - **Name:** `gaf-sync`
  - **Type:** `command`
  - **Command:** `node "[YOUR_GAF_PATH]\tools\mcp\gaf_bridge.js"`

### 2. Cline / Roo-Code (VSCode)
- Click on the **MCP Console** icon (the bars icon next to the prompt).
- Edit your `mcp_settings.json`:
```json
{
  "mcpServers": {
    "gaf-sync": {
      "command": "node",
      "args": ["[YOUR_GAF_PATH]\\tools\\mcp\\gaf_bridge.js"]
    }
  }
}
```

---

## 🧠 AI Agent Specialists
The GAF ecosystem is built around four specialized personas (found in `agents/`). Each has direct access to the Tool Arsenal but follows different architectural protocols:

- **🎩 Producer:** The project orchestrator. Analyzes intent, manages the roadmap, and delegates to specialists.
- **💻 Lead Engineer:** The architect. Responsible for GDScript implementation, state management, and node tree wiring.
- **🎨 Technical Artist:** The visual expert. Handles UI Anchors, Shaders, Animations, and Level Design.
- **🔬 QA Engineer:** The auditor. Tests stability, stress-tests mechanics with the execution tool, and audits typing standards.

---

## 📂 Framework Structure
```text
Your-Godot-Game-Project/
├── addons/
│   └── gaf_sync/           # 🔌 The Godot Addon: Native Sync Engine.
├── Godot-Agent-Framework/  # 📦 The Framework Monorepo:
│   ├── agents/             # 🧠 Specialist AI profiles.
│   ├── docs/               # 📜 GAF Best Practices & AI Manuals.
│   ├── scripts/            # ⚙️ Installers (setup_project.ps1).
│   └── tools/mcp/          # 🌉 Pure TCP Bridge (gaf_bridge.js).
```

## 🛠️ Tool Arsenal (19+ Native Tools)
- **Scene Manipulation:** Create, delete, duplicate, rename, reparent nodes.
- **Scripting:** Read and hot-reload GDScripts instantly.
- **Type Safety:** Smart parsing for `Vector2/3`, `Color`, `Rect2`, `Quaternions`.
- **Logic:** Connect signals and update properties natively in the Editor.
- **Undo/Redo:** All scene mutations support Godot's native Undo system (`Ctrl+Z`).

## 📡 Advanced Protocol Primitives
- **Resources:** Automatic RAG for `InputMap` and `Autoloads`.
- **Prompts:** Pre-built AI workflows for State Machines and Performance Audits.

---

### 📜 Licensing
Godot Agent Framework (GAF) is released under the **MIT License**.
Copyright (c) 2026 JXUE0.
