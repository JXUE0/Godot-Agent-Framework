#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"
ADDON_ROOT="$PROJECT_ROOT/addons/godot_mcp"
PLUGIN_CFG="$ADDON_ROOT/plugin.cfg"
PLUGIN_GD="$ADDON_ROOT/plugin.gd"
MCP_SERVER="$ADDON_ROOT/mcp_server.gd"

if [[ ! -d "$ADDON_ROOT" ]]; then
  echo "WARN: MCP no instalado (addons/godot_mcp no existe)"
  exit 0
fi

[[ -f "$PLUGIN_CFG" ]] || echo "ERROR: MCP sin plugin.cfg"
[[ -f "$PLUGIN_GD" ]] || echo "ERROR: MCP sin plugin.gd"
[[ -f "$MCP_SERVER" ]] || echo "WARN: MCP sin mcp_server.gd (modo servidor no disponible)"

if [[ -f "$PLUGIN_CFG" ]]; then
  grep -q "name=" "$PLUGIN_CFG" || echo "ERROR: plugin.cfg sin name"
  grep -q "script=" "$PLUGIN_CFG" || echo "ERROR: plugin.cfg sin script"
fi

if [[ -f "$MCP_SERVER" ]]; then
  grep -q "allow_remote_connections\s*:=\s*true" "$MCP_SERVER" && echo "WARN: allow_remote_connections=true (riesgo de seguridad)"
  grep -q "allow_unsafe_commands\s*:=\s*true" "$MCP_SERVER" && echo "WARN: allow_unsafe_commands=true (riesgo de seguridad)"
fi
