# Godot Input — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
### 4.6
- Dual-focus: mouse/touch separado de teclado/gamepad.
- Select Mode ahora `v` (Transform Mode `q`).

### 4.5
- SDL3 para gamepads.
- Recursive Control disable para jerarquias.

## Patrones actuales
```gdscript
func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector(&"left", &"right", &"up", &"down")
```

## Errores comunes
- No probar ambos caminos de focus (mouse vs teclado).
- Asumir que `grab_focus()` afecta mouse.
