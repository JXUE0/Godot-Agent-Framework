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
