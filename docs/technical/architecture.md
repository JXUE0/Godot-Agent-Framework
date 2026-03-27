# Arquitectura del Framework

## Objetivo
GAF es un framework drop-in para proyectos Godot 4.x. Define roles, reglas, herramientas y flujos para que una IA pueda operar con calidad profesional sin romper la arquitectura del juego.

## Componentes principales
- `agents/`: roles con reglas y entregables claros.
- `docs/`: guias de uso, arquitectura, seguridad, engine reference y handoffs.
- `tools/`: validadores, plantillas y utilidades.
- `scripts/`: setup, instalacion MCP y validacion.
- `rules/`: reglas comunes + GDScript.
- `hooks/`: perfiles de control (minimal/standard/strict).

## Limites del framework
- No modifica el juego por defecto.
- No instala addons sin confirmacion.
- No reemplaza decisiones de arquitectura del Lead Engineer.

## Flujo macro
1. IA lee `docs/AI_GUIDE.md` y engine reference.
2. Selecciona rol en `agents/`.
3. Ejecuta tareas con validacion.
4. Documenta y hace handoff.

## Politicas de seguridad
- Solo local por defecto.
- MCP sin conexiones remotas salvo aprobacion.
- Evitar APIs deprecadas.
