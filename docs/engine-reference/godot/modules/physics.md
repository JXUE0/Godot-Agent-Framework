# Godot Physics — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- 4.6: Jolt es default 3D en proyectos nuevos.
- 4.5: Interpolacion 3D re-arquitectada (API estable).

## Patrones actuales
```gdscript
extends CharacterBody3D
@export var speed := 5.0
```

## Errores comunes
- Asumir GodotPhysics3D por defecto.
- Usar `HingeJoint3D.damp` en Jolt sin verificar.
