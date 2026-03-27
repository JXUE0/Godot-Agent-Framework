# Godot Navigation — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- 4.5: NavigationServer2D dedicado (no proxy 3D).

## Patrones actuales
```gdscript
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
```

## Errores comunes
- No usar `is_navigation_finished()` antes de `get_next_path_position()`.
- No setear `velocity` con avoidance habilitado.
