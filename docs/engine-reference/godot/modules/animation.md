# Godot Animation — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes since ~4.3
### 4.6
- IK restored in 3D via `SkeletonModifier3D`.

### 4.5
- `BoneConstraint3D` + modifiers (Aim/Copy/ConvertTransform).

### 4.3
- AnimationPlayer/Tree extend `AnimationMixer`.
- `method_call_mode` → `callback_mode_method`.
- `playback_active` → `active`.
- `bone_pose_updated` → `skeleton_updated`.

## Patterns
### AnimationPlayer
```gdscript
@onready var anim_player: AnimationPlayer = %AnimationPlayer

func play_attack() -> void:
    anim_player.play(&"attack")
    await anim_player.animation_finished
```

### IK (4.6)
```gdscript
# Add a SkeletonModifier3D (TwoBoneIK/FABRIK/CCDIK/etc)
# as a child of Skeleton3D and set bones/targets.
```

### AnimationTree
```gdscript
@onready var anim_tree: AnimationTree = %AnimationTree

func _ready() -> void:
    anim_tree.active = true
```

## Common pitfalls
- Using `playback_active` instead of `active`.
- Using `bone_pose_updated` instead of `skeleton_updated`.
- Using legacy IK.
