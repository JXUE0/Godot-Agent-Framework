# MCP — Guia Tecnica

## Que es
El addon MCP expone herramientas del editor Godot via WebSocket local. Permite inspeccionar y modificar el proyecto desde una IA.

## Flujo
1. Godot ejecuta el servidor MCP en el editor.
2. La IA se conecta via WebSocket.
3. El plugin ejecuta herramientas y devuelve resultados.

## Puerto y seguridad
- Puerto default: 9081.
- No habilitar conexiones remotas sin aprobacion.
- Deshabilitar comandos inseguros salvo necesidad.

## Instalacion rapida
- `scripts/install_mcp.*` copia el addon limpio a `addons/godot_mcp`.
- Activar el plugin en Godot: Project > Project Settings > Plugins.

## Validacion MCP
`tools/mcp/validate_mcp.*` verifica:
- Presencia de addon
- plugin.cfg y plugin.gd
- seguridad basica
