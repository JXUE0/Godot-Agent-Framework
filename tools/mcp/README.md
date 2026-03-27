# MCP (Godot MCP)

## Proposito
Habilitar integracion segura con Godot MCP cuando el proyecto ya tenga el addon instalado.

## Instrucciones
1. Verifica que exista `addons/godot_mcp` en el proyecto Godot.
2. No copiar ni modificar el addon sin aprobacion del usuario.
3. Usar MCP para:
   - Inspeccionar escenas y recursos
   - Validar estructura
   - Automatizar tareas seguras

## Ejemplos
- Detectar addon: buscar carpeta `addons/godot_mcp`.
- Validar configuracion: revisar settings del addon antes de usar.

## Limitaciones
- No habilitar conexiones remotas sin aprobacion.
- No ejecutar comandos inseguros.
- Si el addon no existe, registrar warning y continuar.
\n\n## Addon limpio (template)\nEste repo incluye un addon MCP limpio y generico para Godot en:\n	ools/mcp/addon_template/addons/godot_mcp\n\nUso sugerido:\n1. Copiar ddons/godot_mcp al proyecto Godot.\n2. Activar el plugin en el editor.\n3. Configurar URL/puerto si aplica (por defecto: ws://localhost:6505).\n\nNota: El template no contiene referencias a ningun proyecto especifico.\n
\n\n## Diagrama de flujo (alto nivel)\n\n`
[IA / Cliente] \n    | WebSocket (localhost:9081)\n    v\n[Godot MCP Plugin]\n    | ToolExecutor\n    v\n[Tools: file/scene/script/project/assets]\n    | Resultados\n    v\n[IA]\n`
\n### Resumen\n- Godot ejecuta el servidor local MCP.\n- La IA envia comandos por WebSocket.\n- El plugin procesa y responde con resultados.\n
