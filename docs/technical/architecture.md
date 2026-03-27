# Framework Architecture

## Purpose
GAF is a drop‑in framework for Godot 4.x. It defines roles, rules, tools, and workflows so AI can operate professionally without breaking the game architecture.

## Core components
- `agents/`: roles with rules and deliverables.
- `docs/`: guides, architecture, security, engine reference, handoffs.
- `tools/`: validators, templates, utilities.
- `scripts/`: setup, MCP install, validation.
- `rules/`: common + GDScript rules.
- `hooks/`: control profiles (minimal/standard/strict).

## Framework boundaries
- Does not modify the game by default.
- Does not install addons without confirmation.
- Does not override Lead Engineer decisions.

## Macro flow
1. AI reads `docs/AI_GUIDE.md` and engine reference.
2. Selects a role in `agents/`.
3. Executes tasks with validation.
4. Documents and hands off.

## Security policy
- Local only by default.
- MCP without remote connections unless approved.
- Avoid deprecated APIs.
