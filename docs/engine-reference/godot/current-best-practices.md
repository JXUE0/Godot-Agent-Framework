# 🌟 GODOT 4.X — CURRENT BEST PRACTICES (GAF)
> [!IMPORTANT]
> **DEVELOPMENT STANDARD:** All agents MUST follow these patterns to ensure high-quality, maintainable code for Godot 4.3+.

## 💻 GDSCRIPT (STRICT MODE)

- **Static Typing:** Always use types for variables, functions, and arguments. 
  `var speed: int = 100` | `func _move(dir: Vector2) -> void:`
- **Annotations (@):** Use the new `@` system for all editor-related logic.
  `@export`, `@onready`, `@tool`, `@rpc`.
- **Node Access (Unique Names %):** Prefer **Unique Scene Names** over absolute paths.
  `get_node("%PlayerIcon")` is safer than `get_node("UI/HB/PlayerIcon")`.
- **Await/Signals:** Use the modern async system.
  `await get_tree().create_timer(1).timeout`.

## 🏗️ SYSTEM ARCHITECTURE (COMPOSITION)

- **Components over Inheritance:** Use child nodes as "Components" (e.g., `HealthComponent`, `HitboxComponent`). This makes systems decouplable and reusable.
- **Resources (.tres):** Store data (stats, items, configs) in custom **Resources**. IAs should read/write `.tres` files for data-driven gameplay.
- **Signals for Upward Communication:** 
  - *Downward:* Call methods (Parent -> Child).
  - *Upward:* Use Signals (Child -> Parent).
  - *Lateral:* Avoid direct coupling; use an Event Bus or a "Manager" node.

## 🛠️ THE NEW 4.X PHYSICS & NAVIGATION

- **CharacterBody2D/3D:** Use the built-in `move_and_slide()` pattern. 
  *Rule:* Set `velocity` first, then call the method.
- **Navigation Agents:** Use `NavigationAgent2D/3D` nodes instead of the old NavigationServer methods. Set the target position and react to the `velocity_computed` signal.

## 🎨 RENDERING & POST-PROCESS

- **WorldEnvironment:** Centralize your lighting and fog settings in a single `.tres` environment resource.
- **UI Responsiveness:** Always use **Containers** (Margin, Grid, VBox, HBox). Never position UI elements freely unless they are meant to be overlay popups.
- **Shaders:** Favor `VisualShader` for simple effects and `ShaderMaterial` with `.gdshader` for complex logic. Use `StandardMaterial3D` for basic 3D assets.

## 📂 PROJECT HYGIENE

- **Naming:** `PascalCase` for ClassNames and `snake_case` for everything else (files, variables, methods).
- **Cleanup:** Always use `.queue_free()` to remove nodes safely.
- **Documentation:** Use `@doc` comments for any public-facing API you create.

---
*Verified for Godot 4.3/4.6 | Godot Agent Framework (GAF)*
