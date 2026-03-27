# Guia Tecnica de Herramientas

## Validadores
- `asset_validator`: nombres, temporales, archivos pesados.
- `structure_enforcer`: estructura base, scene templates, carpetas recomendadas.
- `deprecated_apis`: detecta APIs obsoletas en .gd.
- `mcp validator`: comprueba instalacion MCP.

## Reportes
- `docs_generator` genera `docs/generated/validation-report.md`.

## Scripts
- `scripts/validate_project.*` ejecuta todos los validadores.
- `scripts/install_mcp.*` instala MCP.
- `scripts/setup_project.*` orquesta instalacion + validacion.
