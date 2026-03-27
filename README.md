# Godot Agent Framework (GAF) - V1.3.1 (Pure TCP)

The **Godot Agent Framework (GAF)** is a professional, high-performance, and secure ecosystem designed to empower AI Agents in autonomous game development. It establishes a robust bi-directional communication channel between AI models and the Godot Editor API, enabling real-time scene manipulation, script editing, and project lifecycle management.

## 🏛️ Ecosystem Architecture

GAF is organized into specialized modules to ensure maximum flexibility and reliability across different development environments:

### 1. The Intelligence Layer (`agents/`)
Contains specialized AI profiles designed to execute complex Godot tasks:
- **Lead Engineer:** Orchestrates framework health and deployment.
- **Gameplay Programmer:** Implements mechanics and logic systems.
- **Technical Artist:** Manages visual assets, shaders, and scene layouts.

### 2. The Communication Tunnel (`tools/mcp/`)
The **GAF-Bridge** is a lightweight, zero-dependency Node.js gateway that routes instructions:
- **Protocol:** Pure TCP (Standard JSON-RPC 2.0).
- **Port:** Static 1342.
- **Security:** Localhost filtering (IP Loopback only, 127.0.0.1).
- **Isolation:** No external packages required (`npm install`-free).

### 3. The Execution Engine (`addons/gaf_sync/`)
The **GAF-Sync Engine** is a native Godot Editor Plugin that serves as the AI's "hands" inside the engine:
- **Connectivity:** TCP Client mode connecting to GAF-Bridge.
- **Access:** Direct interface with `EditorInterface`, `EditorFileSystem`, and `SceneTree`.
- **Feedback:** Real-time visual status reporting in the Editor console.

### 4. The Automation Subsystem (`scripts/`)
Infrastructure tools for seamless framework integration:
- `setup_project.ps1`: Automated project setup and plugin deployment.
- `install_mcp.ps1`: One-click GAF-Sync injection into target projects.

## ⚙️ How it Works (The GAF Loop)

The framework follows a deterministic command-and-execution cycle:
1. **Request:** The AI Agent generates a JSON-RPC command (e.g., `create_node`).
2. **Tunneling:** GAF-Bridge receives the request via STDIO and forwards it through the TCP 1342 socket.
3. **Execution:** GAF-Sync Engine parse the request, executes the corresponding Godot Editor API call, and captures the result.
4. **Response:** Synchronized result or project state is returned through the tunnel back to the Agent.

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

### Professional Standards & Licensing
GAF is built for high-level engineering environments. It is a derivative work evolved from Solomon Elias's **godot-mcp**. Full legal and third-party details are documented in `THIRD_PARTY_NOTICES.md`.
