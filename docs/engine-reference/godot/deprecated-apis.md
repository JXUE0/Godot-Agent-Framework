# Godot — Deprecated APIs
Last verified: 2026-02-12

Si un agente sugiere algo en la columna Deprecated, debe reemplazarlo por Use Instead.

## Nodes & Classes

| Deprecated | Use Instead | Since | Notes |
|---|---|---|---|
| `TileMap` | `TileMapLayer` | 4.3 | Un nodo por layer. |
| `VisibilityNotifier2D` | `VisibleOnScreenNotifier2D` | 4.0 | Renombrado. |
| `VisibilityNotifier3D` | `VisibleOnScreenNotifier3D` | 4.0 | Renombrado. |
| `YSort` | `Node2D.y_sort_enabled` | 4.0 | Propiedad en Node2D. |
| `Navigation2D/3D` | `NavigationServer2D/3D` | 4.0 | API por servidor. |
| `EditorSceneFormatImporterFBX` | `EditorSceneFormatImporterFBX2GLTF` | 4.3 | Renombrado. |

## Methods & Properties

| Deprecated | Use Instead | Since | Notes |
|---|---|---|---|
| `yield()` | `await signal` | 4.0 | Corutinas GDScript 2.0. |
| `connect("signal", obj, "method")` | `signal.connect(callable)` | 4.0 | Conexiones tipadas. |
| `instance()` | `instantiate()` | 4.0 | Renombrado. |
| `PackedScene.instance()` | `PackedScene.instantiate()` | 4.0 | Renombrado. |
| `get_world()` | `get_world_3d()` | 4.0 | Separacion 2D/3D. |
| `OS.get_ticks_msec()` | `Time.get_ticks_msec()` | 4.0 | Preferir Time. |
| `duplicate()` en recursos anidados | `duplicate_deep()` | 4.5 | Copia profunda explicita. |
| `Skeleton3D.bone_pose_updated` | `skeleton_updated` | 4.3 | Renombrado. |
| `AnimationPlayer.method_call_mode` | `AnimationMixer.callback_mode_method` | 4.3 | Movido a base class. |
| `AnimationPlayer.playback_active` | `AnimationMixer.active` | 4.3 | Movido a base class. |

## Patrones (No solo APIs)

| Deprecated Pattern | Use Instead | Why |
|---|---|---|
| `connect()` con strings | Conexiones tipadas | Refactor-safe. |
| `$NodePath` en `_process()` | `@onready var` cacheado | Evita lookups cada frame. |
| `Array/Dictionary` sin tipo | Tipado (`Array[Type]`) | Mejor optimizacion. |
| `Texture2D` en shaders | `Texture` | Cambio 4.4. |
| Viewport chains manuales | `Compositor` + `CompositorEffect` | Post-proceso estructurado. |
| GodotPhysics3D por defecto | Jolt Physics 3D | Default desde 4.6. |
