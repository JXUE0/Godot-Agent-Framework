#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-}"

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "[GAF] Usage: ./scripts/gaf.sh /path/to/project"
  exit 1
fi

FRAMEWORK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADDON_DIR="$PROJECT_ROOT/addons/godot_mcp"

if [[ -d "$ADDON_DIR" ]]; then
  echo "[GAF] MCP already installed at $ADDON_DIR"
else
  bash "$FRAMEWORK_ROOT/scripts/install_mcp.sh" "$PROJECT_ROOT"
fi

bash "$FRAMEWORK_ROOT/scripts/validate_project.sh"
