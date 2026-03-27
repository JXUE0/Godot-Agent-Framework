# Rules — GDScript

Godot/GDScript rules for GAF.

## Conventions
- Prefer static typing when possible.
- Use `@onready` to cache nodes.
- Use `signal.connect(callable)` (no string connections).

## Forbidden
- `yield()` (use `await`).
- `instance()` (use `instantiate()`).
- `TileMap` (use `TileMapLayer`).

## Best practices
- Avoid `$NodePath` in `_process()`.
- Avoid overusing autoloads.
- Keep scenes small and composable.

## Editor & tools
- Use `@tool` for editor‑time scripts.
- Prefer `EditorScript` for editor automation.

## Signals
- Use `signal.connect(callable)` instead of strings.
- Disconnect in `_exit_tree()` when applicable.

## @tool safety
- Separate editor/runtime logic using `Engine.is_editor_hint()`.
- Avoid disk writes in `_process()` when using `@tool`.
