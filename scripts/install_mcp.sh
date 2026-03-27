#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"
FORCE="${2:-}"

ADDON_SRC="$(cd "$(dirname "$0")/.." && pwd)/tools/mcp/addon_template/addons/godot_mcp"
ADDON_DST="$PROJECT_ROOT/addons/godot_mcp"

if [[ -d "$ADDON_DST" ]]; then
  echo "[GAF][MCP] MCP already installed at $ADDON_DST. No changes made."
  exit 0
fi

echo "[GAF][MCP] Installing addon..."
mkdir -p "$(dirname "$ADDON_DST")"
cp -R "$ADDON_SRC" "$ADDON_DST"

echo "[GAF][MCP] Installation complete"
echo "[GAF][MCP] Enable the plugin in Project > Project Settings > Plugins"
