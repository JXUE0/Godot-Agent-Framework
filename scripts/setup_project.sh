#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-}"
INSTALL_MCP="${2:-}"
FORCE_MCP="${3:-}"
RUN_VALIDATION="${4:-}"

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT="$(cd "$FRAMEWORK_ROOT/.." && pwd)"
fi

PROJECT_FILE="$PROJECT_ROOT/project.godot"
if [[ ! -f "$PROJECT_FILE" ]]; then
  echo "[GAF][Setup] project.godot no encontrado en $PROJECT_ROOT."
  echo "[GAF][Setup] Usa ./scripts/setup_project.sh /ruta/al/proyecto"
  exit 1
fi

echo "[GAF][Setup] Proyecto detectado: $PROJECT_ROOT"

if [[ "$INSTALL_MCP" == "--install-mcp" ]]; then
  echo "[GAF][Setup] Instalando MCP..."
  if [[ "$FORCE_MCP" == "--force-mcp" ]]; then
    "$FRAMEWORK_ROOT/scripts/install_mcp.sh" "$PROJECT_ROOT" --force
  else
    "$FRAMEWORK_ROOT/scripts/install_mcp.sh" "$PROJECT_ROOT"
  fi
fi

if [[ "$RUN_VALIDATION" == "--validate" ]]; then
  echo "[GAF][Setup] Ejecutando validacion..."
  "$FRAMEWORK_ROOT/scripts/validate_project.sh"
fi

echo "[GAF][Setup] Completado"
