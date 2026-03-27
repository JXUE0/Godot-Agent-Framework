# MCP Installation (Windows / Linux)

This guide provides step-by-step installation without screenshots.

## Prerequisites
- Godot project with `project.godot`
- GAF cloned inside the project (drop-in)

---

## Windows (PowerShell)

### 1) Open PowerShell in the GAF folder
```
my_godot_game/godot-agent-framework/
```

### 2) Install MCP (recommended)\n`powershell\n.\\scripts\\install_mcp.cmd C:\\ruta\\a\\tu_proyecto\n`\n\n### 3) If MCP already exists, force reinstall (backup created)\n`powershell\n.\\scripts\\install_mcp.ps1 -ProjectRoot C:\\ruta\\a\\tu_proyecto -Force\n`\n\n If MCP already exists, force reinstall (backup created)
```powershell
.\scripts\install_mcp.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -Force
```

### 4) Enable plugin in Godot
- Open Godot
- Project → Project Settings → Plugins
- Enable **Godot MCP**

### 5) Validate
```powershell
.\scripts\validate_project.ps1
```

---

## Linux/macOS (Bash)

### 1) Open terminal in the GAF folder
```
my_godot_game/godot-agent-framework/
```

### 2) Install MCP
```bash
./scripts/install_mcp.sh /ruta/a/tu_proyecto
```

### 3) Force reinstall (backup created)
```bash
./scripts/install_mcp.sh /ruta/a/tu_proyecto --force
```

### 4) Enable plugin in Godot
- Open Godot
- Project → Project Settings → Plugins
- Enable **Godot MCP**

### 5) Validate
```bash
./scripts/validate_project.sh
```

---

## Notes
- The MCP addon must live in `addons/godot_mcp` for Godot to recognize it.
- The installer copies from `tools/mcp/addon_template/`.
- If validation fails, check `docs/generated/validation-report.md`.

