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
\n\n## Editor y herramientas\n- Usar @tool en scripts que interactuan con el editor.\n- Preferir EditorScript para automatizacion en editor.\n\n## Senales\n- Usar signal.connect(callable) en lugar de strings.\n- Desconectar en _exit_tree() cuando aplique.\n
