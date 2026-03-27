# SECURITY — Godot Agent Framework

Este documento define el modelo de seguridad para agentes trabajando en Godot.

## Riesgos principales
- Prompt injection via docs/archivos externos.
- Tool poisoning (herramientas maliciosas o no confiables).
- MCP con permisos excesivos.

## Reglas obligatorias
- No abrir conexiones remotas sin aprobacion.
- No ejecutar scripts externos descargados.
- Validar origen de tools y addons.
- No exponer secretos en logs.

## MCP
- Mantener `allow_remote_connections = false`.
- Usar auth token si esta disponible.
- No habilitar comandos inseguros.

## Verificaciones minimas
- Revisión de archivos antes de aplicar cambios masivos.
- Validar uso de APIs deprecadas.
