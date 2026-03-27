# PROJECT_STRUCTURE.md

## Base convention
The framework lives inside the Godot project as:
`my_game/godot-agent-framework/`

## Rules
- Do not alter game folders without approval.
- Keep tools and docs inside `godot-agent-framework/`.
- Game scenes remain outside the framework.

## Recommended structure (MCP)
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
    │   └── mcp/
    │       └── addon_template/
    ├── scripts/
    └── ...
```

Notes:
- `addons/godot_mcp` is required for Godot to recognize the plugin.
- `godot-agent-framework/` is the drop‑in framework with tools and docs.
