#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"
FORCE="${2:-}"

ADDON_SRC="$(cd "$(dirname "$0")/.." && pwd)/tools/mcp/addon_template/addons/gaf_sync"
ADDON_DST="$PROJECT_ROOT/addons/gaf_sync"

if [[ -d "$ADDON_DST" ]] && [[ "$FORCE" != "--force" ]] && [[ "$FORCE" != "-f" ]]; then
  echo "[GAF][MCP] GAF-Sync already installed at $ADDON_DST."
  echo "[GAF][MCP] Use --force or -f to overwrite."
  exit 0
fi

if [[ -d "$ADDON_DST" ]]; then
  rm -rf "$ADDON_DST"
fi

echo "[GAF][MCP] Installing addon..."
mkdir -p "$(dirname "$ADDON_DST")"
cp -R "$ADDON_SRC" "$ADDON_DST"

echo "[GAF][MCP] Installation complete"
echo "[GAF][MCP] Enable the plugin in Project > Project Settings > Plugins"
