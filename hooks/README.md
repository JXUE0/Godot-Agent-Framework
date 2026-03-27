# Hooks — Overview

Hooks ligeros para proteger el flujo de trabajo del agente.

## Perfiles
- `minimal`: solo bloqueos criticos.
- `standard`: bloqueos + validaciones clave.
- `strict`: validaciones exhaustivas.

## Hooks sugeridos
- `PreToolUse`: bloquear escrituras fuera de `godot-agent-framework/` sin aprobacion.
- `PostToolUse`: ejecutar `scripts/validate_project.*` si hubo cambios.
- `PreCompact`: confirmar que la documentacion fue actualizada.
