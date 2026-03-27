# SECURITY — Godot Agent Framework

## Key risks
- Prompt injection via docs/external files.
- Tool poisoning (untrusted tools).
- MCP with excessive permissions.

## Mandatory rules
- No remote connections without approval.
- Do not execute downloaded scripts.
- Validate tool/addon origins.
- Do not expose secrets in logs.

## MCP
- Keep `allow_remote_connections = false`.
- Use auth token if available.
- Do not enable unsafe commands.

## Minimum checks
- Review files before applying mass changes.
- Validate deprecated API usage.
