# AI_GUIDE.md

## 1. Mandatory flow for any AI
1. Read this file.
2. Select a role in `agents/`.
3. Review `docs/engine-reference/godot/README.md` before suggesting APIs.
4. Review `docs/PROJECT_STRUCTURE.md` and `docs/GODOT_BEST_PRACTICES.md`.
5. Propose a plan.
6. Execute tasks with validation.
7. Document changes.
8. Notify `agents/producer.md`.

## 2. Strict rules
- Never change project structure without Lead Engineer approval.
- Never create scenes outside defined folders.
- Always document changes.
- Validate assets and scripts before delivery.
- Follow GDScript conventions.

## 3. Run GAF (single entrypoint)
If the user says "Run GAF" or "Execute GAF", always run the entrypoint:
- Windows: `scripts/gaf.cmd C:\ruta\tu_proyecto`
- macOS/Linux: `./scripts/gaf.sh /ruta/tu_proyecto`

This command automatically:
1. Installs `addons/godot_mcp` if missing.
2. Runs full validation.
3. Writes report to `docs/generated/validation-report.md`.

## 4. Addon integration (e.g., godot_mcp)
This framework does NOT copy addons by default. If the project already has `addons/godot_mcp`, the AI must:
- Detect the addon.
- Use it as an available tool.
- Not modify it without explicit approval.

## 5. Important scripts
- `scripts/gaf.*` is the official entrypoint (auto MCP + validate).
- `scripts/setup_project.*` prepares the environment.
- `scripts/validate_project.*` validates structure and standards.
- `scripts/generate_docs.*` generates technical documentation.

## 6. Collaboration
- Lead Engineer defines architecture.
- Architecture Strategist validates structure.
- QA validates changes.
- Producer coordinates deliveries.

## 7. Rules & hooks
- Base rules in `rules/common/`
- Godot rules in `rules/gdscript/`
- Hooks in `hooks/` (profiles minimal/standard/strict)

## Quickstart (5 steps)
1. Read `docs/AI_GUIDE.md` and `docs/engine-reference/godot/README.md`.
2. Select a role in `agents/` and review its rules.
3. Run `scripts/gaf.*` or `scripts/validate_project.*` to assess project state.
4. Propose a plan and coordinate with Lead/QA/Producer.
5. Execute changes and document a handoff.
