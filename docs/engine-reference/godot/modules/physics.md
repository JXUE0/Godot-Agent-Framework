# Godot Physics — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- 4.6: Jolt default 3D engine for new projects.
- 4.5: 3D interpolation re-architected.

## Pattern
```gdscript
extends CharacterBody3D
@export var speed := 5.0
```

## Common pitfalls
- Assuming GodotPhysics3D default.
- Using `HingeJoint3D.damp` in Jolt without verifying.
