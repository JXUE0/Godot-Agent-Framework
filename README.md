# Godot Agent Framework (GAF)

**EN:** Drop‑in framework for Godot 4.x so AI can work like a professional studio team: clear roles, strict rules, real tooling, and MCP integration.  
**ES:** Framework drop‑in para Godot 4.x para que la IA trabaje como un equipo profesional: roles claros, reglas estrictas, tooling real e integración MCP.

## Highlights
- Professional agent roles with strict rules and handoffs.
- Godot 4.x engine reference (breaking changes, deprecated APIs).
- Real validators (structure, assets, deprecated APIs, MCP).
- Clean MCP template + installers.
- Deterministic workflows and technical documentation.

## Quickstart
```text
1) Clone this repo inside your Godot project:
   my_godot_game/godot-agent-framework/
2) Run setup (installs MCP + validates):
   Windows: .\scripts\setup_project.ps1 -ProjectRoot C:\ruta\tu_proyecto -InstallMCP -RunValidation
   macOS/Linux: ./scripts/setup_project.sh /ruta/tu_proyecto --install-mcp --validate
3) Read docs/AI_GUIDE.md and follow the workflow.
```

## Installation (Drop‑in)
1. Clone/download inside your Godot project.
2. (Optional) Install MCP with the scripts.
3. Run validation and follow `docs/AI_GUIDE.md`.

## Automatic setup
Windows:
```powershell
.\scripts\setup_project.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -InstallMCP -RunValidation
# Force MCP reinstall
.\scripts\setup_project.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -InstallMCP -ForceMCP -RunValidation
```

macOS/Linux:
```bash
./scripts/setup_project.sh /ruta/a/tu_proyecto --install-mcp --validate
# Force MCP reinstall
./scripts/setup_project.sh /ruta/a/tu_proyecto --install-mcp --force-mcp --validate
```

## Validation
- Run `scripts/validate_project.*` to execute all checks.
- Report generated at `docs/generated/validation-report.md`.

## MCP (Addon)
- Clean template at `tools/mcp/addon_template/`.
- Quick install via `scripts/install_mcp.*`.
- Godot recognizes the plugin when placed in `addons/godot_mcp`.

## Recommended structure
```
my_godot_game/
├── project.godot
├── addons/
│   └── godot_mcp/
├── scenes/
├── scripts/
├── assets/
└── godot-agent-framework/
    ├── agents/
    ├── docs/
    ├── tools/
    ├── scripts/
    └── ...
```

## Documentation
- Docs index: `docs/README.md`
- AI Guide: `docs/AI_GUIDE.md`
- Engine Reference: `docs/engine-reference/godot/README.md`
- Security: `docs/SECURITY.md`
- Handoffs: `docs/handoffs/`

## License
MIT
