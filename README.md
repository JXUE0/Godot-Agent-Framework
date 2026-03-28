# 🤖 Godot Agent Framework (GAF)

![Godot Engine](https://img.shields.io/badge/Godot-4.3+-blue?logo=godot-engine&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Native_Bridge-green?logo=node.js)
![MCP](https://img.shields.io/badge/Protocol-MCP_JSON--RPC-orange)

[Español (Spanish)](docs/es/README.md)

---

The **Godot Agent Framework (GAF)** is a high-performance, secure, and fully-featured ecosystem designed to empower AI Agents in autonomous game development. It establishes a robust bi-directional communication channel between AI models and the Godot Editor API via the **Model Context Protocol (MCP)**.

## 🏁 Quick Start & Tips

If you are a human setting this up for the first time:
1. **Clone this repo** inside your Godot project folder.
2. **Run the installer:** Execute `scripts/setup_project.ps1` (PowerShell) to inject the addon.
3. **Enable the Plugin:** Open Godot, go to `Project Settings > Plugins` and enable `gaf_sync`.
4. **Configure your AI:** Follow the [MCP Setup](#-mcp-installation--config) below.

---

## 💡 Pro Tips for AI Pair-Programming

> [!TIP]
> **⌘ The `Undo` Safety Net:** All AI actions that modify the SceneTree are wrapped in native Godot `UndoRedo` operations. If the AI messes up, just click on the **Godot Editor** and press `Ctrl + Z`!

> [!IMPORTANT]
> **📦 Version Control is King:** Always commit your Godot project to Git **before** asking the AI for a massive architectural refactoring. `git add . && git commit -m "pre-ai-work"`.

> [!NOTE]
> **🤖 Agents Roles:** Address the AI specifically to trigger specialist behaviors. For example: *"Read your Technical Artist agent profile and fix my UI anchors"*.

> [!INFO]
> **⚡ Zero NPM Bloat:** The Node.js bridge uses zero external dependencies. No annoying `npm install` required.

---

## 📡 MCP Installation & Config

To enable the AI to use these tools, you must register the **GAF-Sync Bridge** in your AI IDE settings.

### 1. Cursor IDE (Standard)
- Go to `Settings > Cursor Settings > MCP`.
- Add a new MCP Server:
  - **Name:** `gaf-sync`
  - **Type:** `command`
  - **Command:** `node "[YOUR_GAF_PATH]\tools\mcp\gaf_bridge.js"`

### 2. Cline / Roo-Code / Continue (VSCode)
- Click on the **MCP Console** icon (or Settings > MCP in Continue).
- Edit your `mcp_settings.json` or equivalent:
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

### 3. Windsurf (Codeium)
- Open Windsurf `mcp_config.json`.
- Add the `gaf-sync` configuration using the same JSON format as above.

### 4. Claude Desktop
- Open `%APPDATA%\Claude\claude_desktop_config.json`.
- Add the `gaf-sync` configuration under `mcpServers`.

---

## 🚀 Supported AI Environments
The **GAF** is built on the universal **Model Context Protocol (MCP)**, making it compatible with the industry's most advanced AI coding tools:
- **Cursor:** The leading AI-native IDE.
- **VSCode (Cline / Roo-Code / Continue):** The most popular open-weight agent extensions.
- **Windsurf:** The state-of-the-art "Flow" based agent IDE.
- **Claude Desktop:** The official app from Anthropic.

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
