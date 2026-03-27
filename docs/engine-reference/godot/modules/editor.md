# Godot Editor Tooling — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- EditorDock nuevo para plugins (4.6).
- Tema Modern por defecto (4.6).

## Patrones actuales
- Usar `EditorPlugin` + `EditorDock`.
- Mantener herramientas separadas del runtime.

## Errores comunes
- Inyectar nodos en escenas del juego desde tooling.
