# Godot Agent Framework (GAF)

[![CI](https://github.com/JXUE0/Godot-Agent-Framework/actions/workflows/ci.yml/badge.svg)](https://github.com/JXUE0/Godot-Agent-Framework/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/JXUE0/Godot-Agent-Framework)](https://github.com/JXUE0/Godot-Agent-Framework/releases)
[![Pages](https://img.shields.io/badge/pages-live-brightgreen)](https://jxue0.github.io/Godot-Agent-Framework/)

**EN:** Drop-in framework for Godot 4.x so AI can work like a professional studio team: clear roles, strict rules, real tooling, and MCP integration.  
**ES:** Framework drop-in para Godot 4.x para que la IA trabaje como un equipo profesional: roles claros, reglas estrictas, tooling real e integracion MCP.

---

## 🤖 AI Models & Compatibility
GAF is designed to be **Universal**. It provides automatic configuration for the following AI environments:

| Tool / Model | Entry Point | GAF Access | Recommended Roles |
| :--- | :--- | :--- | :--- |
| **Cursor / Windsurf** | `.cursorrules` | Full access to `agents/`, `docs/`, `tools/` | All Specialists |
| **Cline / Roo Code** | `.clinerules` | Full project context + Agent workflows | Architecture & QA |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Inline chat & code completion context | Progamming & Debugging |
| **ChatGPT / Claude Web**| `AI_BOOTSTRAP.md` | User must upload or point to this file | Strategic Planning |

> [!TIP]
> **Universal Prompt:** If your AI doesn't recognize the framework automatically, paste this:
> *"I am using Godot Agent Framework (GAF). Please read the documentation in `godot-agent-framework/agents/` and assume the role of the best agent for my next request."*

---

## ⚙️ How it Works (AI Workflow)
When you ask for a feature, the AI will:
1. **Identify Role**: Accesses `agents/` to choose a specialist (e.g., `gameplay_programmer.md`).
2. **Context Check**: Reads `docs/engine-reference/` to avoid Godot 3.x legacy code.
3. **Execute via MCP**: Uses the `godot_mcp` addon tools to interact with your Scene Tree in real-time.
4. **Handoff**: Generates a professional report in `docs/handoffs/`.

---

## 🚀 Quickstart
1. Clone this repo inside your Godot project:
   `my_godot_game/godot-agent-framework/`
2. Run GAF Setup (installs MCP + AI Rules):
   - **Windows:** `.\scripts\setup_project.ps1 -ProjectRoot ..\ -InstallMCP`
   - **macOS/Linux:** `./scripts/setup_project.sh ../ --install-mcp`
3. Ask your AI to perform a task. It will automatically detect `.cursorrules` or `.clinerules`.

---

## 🏗️ Folder Structure
```
my_godot_game/
|-- .cursorrules           <-- AI Brain (Root)
|-- .clinerules            <-- AI Brain (Root)
|-- .github/               <-- Copilot instructions
|-- addons/godot_mcp/      <-- MCP Server (Plugin)
`-- godot-agent-framework/
    |-- agents/            <-- Role-based Agent MDs
    |-- docs/              <-- Engine Ref & Handoff templates
    |-- tools/             <-- MCP Template & installers
    `-- scripts/           <-- Validation & Setup scripts
```

## 🛠️ Validation
Run `scripts/validate_project.*` to execute all checks. Report generated at `docs/generated/validation-report.md`.

## 📜 Documentation
- Docs index: `docs/README.md`
- AI Guide: `docs/AI_GUIDE.md`
- Engine Reference: `docs/engine-reference/godot/README.md`
- Handoffs: `docs/handoffs/`

## ⚖️ License
MIT. See THIRD_PARTY_NOTICES.md for MCP addon credits (based on Coding-Solo).
