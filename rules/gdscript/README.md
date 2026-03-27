# Rules — GDScript

Reglas especificas para Godot/GDScript 4.x.

## Convenciones
- Tipado estatico cuando aplique.
- `@onready` para cachear nodos.
- Señales con `signal.connect(callable)` (no strings).

## Prohibido
- `yield()` (usar `await`).
- `instance()` (usar `instantiate()`).
- `TileMap` (usar `TileMapLayer`).

## Buenas practicas
- Evitar `$NodePath` en `_process()`.
- No abusar de autoloads.
- Mantener escenas pequeñas y composables.
