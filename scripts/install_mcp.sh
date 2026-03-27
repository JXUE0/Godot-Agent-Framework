#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-}"
FORCE="${2:-}"

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT="$(cd "$FRAMEWORK_ROOT/.." && pwd)"
fi

PROJECT_FILE="$PROJECT_ROOT/project.godot"
if [[ ! -f "$PROJECT_FILE" ]]; then
  echo "[GAF][MCP] project.godot no encontrado en $PROJECT_ROOT."
  echo "[GAF][MCP] Usa ./scripts/install_mcp.sh /ruta/al/proyecto"
  exit 1
fi

TEMPLATE_ROOT="$FRAMEWORK_ROOT/tools/mcp/addon_template/addons/godot_mcp"
if [[ ! -d "$TEMPLATE_ROOT" ]]; then
  echo "[GAF][MCP] No se encontro el template en $TEMPLATE_ROOT"
  exit 1
fi

DEST_ROOT="$PROJECT_ROOT/addons/godot_mcp"
if [[ -d "$DEST_ROOT" ]]; then
  if [[ "$FORCE" != "--force" ]]; then
    echo "[GAF][MCP] Ya existe addons/godot_mcp en el proyecto."
    echo "[GAF][MCP] Reintenta con --force para sobrescribir (se crea backup)."
    exit 1
  fi
  STAMP="$(date +%Y%m%d-%H%M%S)"
  BACKUP="$PROJECT_ROOT/addons/godot_mcp.backup-$STAMP"
  echo "[GAF][MCP] Creando backup en $BACKUP"
  cp -R "$DEST_ROOT" "$BACKUP"
  rm -rf "$DEST_ROOT"
fi

echo "[GAF][MCP] Instalando addon..."
cp -R "$TEMPLATE_ROOT" "$DEST_ROOT"

echo "[GAF][MCP] Instalacion completada"
echo "[GAF][MCP] Activa el plugin en Project > Project Settings > Plugins"
