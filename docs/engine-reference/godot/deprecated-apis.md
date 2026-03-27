# Godot — Deprecated APIs
Last verified: 2026-02-12

## Nodes & Classes

| Deprecated | Use Instead | Since | Notes |
|---|---|---|---|
| `TileMap` | `TileMapLayer` | 4.3 | One node per layer. |
| `VisibilityNotifier2D` | `VisibleOnScreenNotifier2D` | 4.0 | Renamed. |
| `VisibilityNotifier3D` | `VisibleOnScreenNotifier3D` | 4.0 | Renamed. |
| `YSort` | `Node2D.y_sort_enabled` | 4.0 | Property on Node2D. |
| `Navigation2D/3D` | `NavigationServer2D/3D` | 4.0 | Server‑based API. |
| `EditorSceneFormatImporterFBX` | `EditorSceneFormatImporterFBX2GLTF` | 4.3 | Renamed. |

## Methods & Properties

| Deprecated | Use Instead | Since | Notes |
|---|---|---|---|
| `yield()` | `await signal` | 4.0 | GDScript 2.0. |
| `connect("signal", obj, "method")` | `signal.connect(callable)` | 4.0 | Typed connections. |
| `instance()` | `instantiate()` | 4.0 | Renamed. |
| `PackedScene.instance()` | `PackedScene.instantiate()` | 4.0 | Renamed. |
| `get_world()` | `get_world_3d()` | 4.0 | 2D/3D split. |
| `OS.get_ticks_msec()` | `Time.get_ticks_msec()` | 4.0 | Prefer Time. |
| `duplicate()` in nested resources | `duplicate_deep()` | 4.5 | Explicit deep copy. |
| `Skeleton3D.bone_pose_updated` | `skeleton_updated` | 4.3 | Renamed. |
| `AnimationPlayer.method_call_mode` | `AnimationMixer.callback_mode_method` | 4.3 | Moved to base class. |
| `AnimationPlayer.playback_active` | `AnimationMixer.active` | 4.3 | Moved to base class. |

## Patterns

| Deprecated Pattern | Use Instead | Why |
|---|---|---|
| String `connect()` | Typed connections | Refactor‑safe. |
| `$NodePath` in `_process()` | Cached `@onready var` | Avoid per‑frame lookups. |
| Untyped Array/Dictionary | Typed collections | Better optimization. |
| `Texture2D` in shaders | `Texture` | 4.4 change. |
| Manual viewport chains | `Compositor` + `CompositorEffect` | Structured post‑process. |
| Default GodotPhysics3D | Jolt 3D | Default since 4.6. |
