# Godot Agent Framework (GAF)

Framework drop-in para proyectos Godot 4.x que permite a cualquier IA trabajar de forma profesional con agentes, herramientas y estándares definidos.

## Que ofrece
- Agentes profesionales con roles y reglas estrictas.
- Engine reference Godot 4.x para evitar APIs deprecadas.
- Herramientas de validacion reales (estructura, assets, deprecated APIs, MCP).
- Integracion MCP limpia y reusable.
- Flujo de trabajo determinista para IA y usuarios.

## Instalacion (Drop-in)
1. Descarga o clona este repositorio dentro de tu proyecto Godot:
   `my_godot_game/godot-agent-framework/`
2. (Opcional) Instala MCP usando el setup automatico.
3. Lee `docs/AI_GUIDE.md` y sigue el flujo.

## Setup automatico
Windows:
```powershell
.\scripts\setup_project.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -InstallMCP -RunValidation
# Forzar reinstalacion MCP
.\scripts\setup_project.ps1 -ProjectRoot C:\ruta\a\tu_proyecto -InstallMCP -ForceMCP -RunValidation
```

macOS/Linux:
```bash
./scripts/setup_project.sh /ruta/a/tu_proyecto --install-mcp --validate
# Forzar reinstalacion MCP
./scripts/setup_project.sh /ruta/a/tu_proyecto --install-mcp --force-mcp --validate
```

## Validacion
- Ejecuta `scripts/validate_project.*` para correr todos los checks.
- Reporte generado en `docs/generated/validation-report.md`.

## MCP (Addon)
- Template limpio en `tools/mcp/addon_template/`.
- Instalacion rapida con `scripts/install_mcp.*`.
- Godot reconoce el plugin si esta en `addons/godot_mcp`.

## Estructura recomendada
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

## Licencia
MIT
