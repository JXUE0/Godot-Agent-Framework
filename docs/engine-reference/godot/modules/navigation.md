# Godot Navigation — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- 4.5: Dedicated NavigationServer2D (not 3D proxy).

## Pattern
```gdscript
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
```

## Common pitfalls
- Not checking `is_navigation_finished()` before `get_next_path_position()`.
- Not setting `velocity` when avoidance is enabled.
