# Godot Input — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- 4.6: Dual focus system (mouse/touch vs keyboard/gamepad).
- 4.5: SDL3 gamepad support.

## Pattern
```gdscript
func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector(&"left", &"right", &"up", &"down")
```

## Common pitfalls
- Not testing both focus paths.
- Assuming `grab_focus()` affects mouse.
