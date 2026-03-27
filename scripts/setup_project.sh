#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-}"
INSTALL_MCP=false
FORCE_MCP=false
VALIDATE=false

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "[GAF][Setup] Usage: ./scripts/setup_project.sh /path/to/project --install-mcp --validate"
  exit 1
fi

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-mcp) INSTALL_MCP=true ;;
    --force-mcp) FORCE_MCP=true ;;
    --validate) VALIDATE=true ;;
  esac
  shift
done

echo "[GAF][Setup] Project detected: $PROJECT_ROOT"

if [[ ! -f "$PROJECT_ROOT/project.godot" ]]; then
  echo "[GAF][Setup] WARNING: project.godot not found in $PROJECT_ROOT"
fi

if $INSTALL_MCP; then
  echo "[GAF][Setup] Installing MCP..."
  if $FORCE_MCP; then
    bash "$(dirname "$0")/install_mcp.sh" "$PROJECT_ROOT" --force
  else
    bash "$(dirname "$0")/install_mcp.sh" "$PROJECT_ROOT"
  fi
fi

if $VALIDATE; then
  bash "$(dirname "$0")/validate_project.sh"
fi

echo "[GAF][Setup] Completed"
