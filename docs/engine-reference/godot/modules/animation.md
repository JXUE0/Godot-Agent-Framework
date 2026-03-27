# Godot Animation — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
### 4.6
- IK restaurado completo (3D) via `SkeletonModifier3D`.
- Mejoras de editor de animacion.

### 4.5
- `BoneConstraint3D` + modifiers (Aim/Copy/ConvertTransform).

### 4.3
- AnimationPlayer/Tree extienden `AnimationMixer`.
- `method_call_mode` → `callback_mode_method`.
- `playback_active` → `active`.
- `bone_pose_updated` → `skeleton_updated`.

## Patrones actuales
### AnimationPlayer
```gdscript
@onready var anim_player: AnimationPlayer = %AnimationPlayer

func play_attack() -> void:
    anim_player.play(&"attack")
    await anim_player.animation_finished
```

### IK (4.6)
```gdscript
# Agrega un SkeletonModifier3D (TwoBoneIK/FABRIK/CCDIK/etc)
# como hijo de Skeleton3D y define huesos/targets.
```

### AnimationTree (base class)
```gdscript
@onready var anim_tree: AnimationTree = %AnimationTree

func _ready() -> void:
    anim_tree.active = true
```

## Errores comunes
- Usar `playback_active` en lugar de `active`.
- Usar `bone_pose_updated` en lugar de `skeleton_updated`.
- Usar IK antigua en vez de `SkeletonModifier3D`.
