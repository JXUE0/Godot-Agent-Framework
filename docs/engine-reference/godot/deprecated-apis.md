# 🚫 GODOT — DEPRECATED APIS & LEGACY PATTERNS
> [!IMPORTANT]
> **COMPLIANCE MANDATORY:** You MUST NOT use any of the deprecated APIs or patterns listed below. Using legacy code will result in a Validation Failure (P0).

## 🏙️ NODES & CLASSES (RENAMED OR REMOVED)

| Deprecated (3.x / 4.0) | Use Instead (4.3+) | Notes |
| :--- | :--- | :--- |
| `TileMap` | `TileMapLayer` | Use one node per layer for performance. |
| `VisibilityNotifier2D/3D` | `VisibleOnScreenNotifier2D/3D` | Renamed for clarity. |
| `YSort` | `Node2D.y_sort_enabled` | Now a property on the parent Node2D. |
| `Navigation2D/3D` | `NavigationServer2D/3D` | Use `NavigationAgent` for most tasks. |
| `Position2D/3D` | `Marker2D/3D` | Renamed. |
| `Spatial` | `Node3D` | Base class for all 3D nodes. |
| `KinematicBody2D/3D` | `CharacterBody2D/3D` | The new standard for player/NPC controllers. |

## ⚙️ METHODS & GDSCRIPT 2.0 (THE TRAP LIST)

| Deprecated Method | Use Instead (4.3+) | CRITICAL WARNING |
| :--- | :--- | :--- |
| `yield()` | `await signal` | `yield` NO LONGER EXISTS. |
| `instance()` | `instantiate()` | Very common AI mistake. |
| `connect("s", o, "m")` | `signal.connect(callable)` | Use `node.signal.connect(self._on_method)`. |
| `OS.get_time()` | `Time.get_time_dict_from_system()` | OS time methods moved to `Time` singleton. |
| `get_world()` | `get_world_2d()` / `get_world_3d()` | Explicit 2D/3D split. |
| `move_and_slide(v)` | `move_and_slide()` | **CRITICAL:** Set `velocity = v` BEFORE calling. |
| `is_action_pressed()` | `Input.is_action_pressed()` | Always use the `Input` singleton. |
| `set_network_master()` | `set_multiplayer_authority()` | Networking overhauled in 4.x. |

## 📐 PATTERNS & ANNOTATIONS

| Deprecated Pattern | Use Instead | Why |
| :--- | :--- | :--- |
| `export var x` | `@export var x` | New annotation system required. |
| `onready var x` | `@onready var x` | New annotation system required. |
| `master func x()` | `@rpc("authority") func x()`| RPCs now use annotations with modes. |
| String node paths | `get_node("%MyNode")` | Use **Unique Scene Names %** for stability. |
| Manual Signal Strings | `signal my_sig(val)` | Signal naming is now fully typed. |

## 🎨 SHADERS & RENDERING (VULKAN ERA)

- **Texture access:** Use `texture(sampler, uv)` instead of `texture2D()`.
- **Built-ins:** `TIME` is now globally available in almost all shader types.
- **Varyings:** Must be declared at the top of the shader file.
- **Compatibility:** Use `render_mode compatibility;` if targeting mobile/web GLES3.

---
*Verified for Godot 4.3+ | Godot Agent Framework (GAF)*
