# Godot Agent Framework (GAF)

[![CI](https://github.com/JXUE0/Godot-Agent-Framework/actions/workflows/ci.yml/badge.svg)](https://github.com/JXUE0/Godot-Agent-Framework/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/JXUE0/Godot-Agent-Framework)](https://github.com/JXUE0/Godot-Agent-Framework/releases)
[![Pages](https://img.shields.io/badge/pages-live-brightgreen)](https://jxue0.github.io/Godot-Agent-Framework/)

**EN:** Drop-in framework for Godot 4.x so AI can work like a professional studio team: clear roles, strict rules, real tooling, and MCP integration.  
**ES:** Framework drop-in para Godot 4.x para que la IA trabaje como un equipo profesional: roles claros, reglas estrictas, tooling real e integracion MCP.

## Highlights
- Professional agent roles with strict rules and handoffs.
- Godot 4.x engine reference (breaking changes, deprecated APIs).
- Real validators (structure, assets, deprecated APIs, MCP).
- Clean MCP template + installers.
- Deterministic workflows and technical documentation.

## Quickstart
1. Clone this repo inside your Godot project:
   `my_godot_game/godot-agent-framework/`
2. Run GAF (auto-installs MCP if missing + runs validation, no backups created):
   Windows: `.scripts\gaf.cmd C:\ruta\tu_proyecto`
   macOS/Linux: `./scripts/gaf.sh /ruta/tu_proyecto`
3. Read `docs/AI_GUIDE.md` and follow the workflow.

## Installation (Drop-in)
1. Clone/download inside your Godot project.
2. (Optional) Install MCP with the scripts.
3. Run validation and follow `docs/AI_GUIDE.md`.

## Automatic setup
Windows:
```powershell
.\scripts\setup_project.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -InstallMCP -RunValidation
```

macOS/Linux:
```bash
./scripts/setup_project.sh /ruta/a/tu_proyecto --install-mcp --validate
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
|-- project.godot
|-- addons/
|   `-- godot_mcp/
|-- scenes/
|-- scripts/
|-- assets/
`-- godot-agent-framework/
    |-- agents/
    |-- docs/
    |-- tools/
    |-- scripts/
    `-- ...
```

## Documentation
- Docs index: `docs/README.md`
- AI Guide: `docs/AI_GUIDE.md`
- Engine Reference: `docs/engine-reference/godot/README.md`
- Security: `docs/SECURITY.md`
- Handoffs: `docs/handoffs/`

## Credits
- Modified MCP addon based on Coding-Solo/godot-mcp (MIT). See THIRD_PARTY_NOTICES.md.

## References
- Godot Engine: https://godotengine.org/
- Godot Docs (stable): https://docs.godotengine.org/en/stable/
- Godot GitHub: https://github.com/godotengine/godot
- Godot Asset Library: https://godotengine.org/asset-library/

## License
MIT

## FAQ
See FAQ.md.

## Security Policy
See SECURITY.md.
