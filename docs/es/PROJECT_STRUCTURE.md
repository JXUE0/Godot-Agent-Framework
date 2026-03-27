# PROJECT_STRUCTURE.md

## Convención base
El framework vive dentro del proyecto Godot como:
`my_game/godot-agent-framework/`

## Reglas
- No alterar carpetas del juego sin aprobación.
- Mantener herramientas y docs dentro de `godot-agent-framework/`.
- Las escenas del juego se mantienen fuera del framework.
\n\n## Estructura recomendada (MCP)\n\n`\nmy_godot_game/\n├── project.godot\n├── addons/\n│   └── godot_mcp/\n├── scenes/\n├── scripts/\n├── assets/\n└── godot-agent-framework/\n    ├── agents/\n    ├── docs/\n    ├── tools/\n    │   └── mcp/\n    │       └── addon_template/\n    ├── scripts/\n    └── ...\n`\n\nNotas:\n- ddons/godot_mcp es obligatorio para que Godot reconozca el plugin.\n- godot-agent-framework/ es el framework drop-in con herramientas y docs.\n
