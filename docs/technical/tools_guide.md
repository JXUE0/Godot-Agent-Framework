# Tools Technical Guide

## Validators
- `asset_validator`: names, temp files, heavy sources.
- `structure_enforcer`: base structure, scene templates, recommended folders.
- `deprecated_apis`: detects obsolete APIs in .gd.
- `mcp validator`: verifies MCP installation.

## Reports
- `docs_generator` generates `docs/generated/validation-report.md`.

## Scripts
- `scripts/validate_project.*` runs all validators.
- `scripts/install_mcp.*` installs MCP.
- `scripts/setup_project.*` orchestrates install + validation.
