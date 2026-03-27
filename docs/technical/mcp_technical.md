# MCP — Technical Guide

## What it is
The MCP addon exposes Godot editor tools via a local WebSocket, enabling AI to inspect and modify projects safely.

## Flow
1. Godot runs the MCP server in the editor.
2. AI connects via WebSocket.
3. The plugin executes tools and returns results.

## Port & security
- Default port: 9081.
- Do not enable remote connections without approval.
- Keep unsafe commands disabled unless needed.

## Quick install
- `scripts/install_mcp.*` copies the clean addon to `addons/godot_mcp`.
- Enable the plugin in Godot: Project > Project Settings > Plugins.

## MCP validation
`tools/mcp/validate_mcp.*` checks:
- addon presence
- plugin.cfg and plugin.gd
- basic security flags
