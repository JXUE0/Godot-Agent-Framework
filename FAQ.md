# FAQ

## Why does validation fail outside a Godot project?
If `project.godot` is missing, the validators run in framework-only mode. Some checks are skipped.

## Do I need MCP to use GAF?
No. MCP is optional, but recommended for advanced automation.

## Why is my MCP not detected?
Ensure `addons/gaf_sync` exists and the plugin is enabled in Project Settings.

## How do I run all checks?
Use `scripts/validate_project.ps1` (Windows) or `scripts/validate_project.sh` (macOS/Linux).
