# QA Pipeline — Godot + GUT

## Goal
Standardize automated tests for agents and humans.

## Recommended flow
1. Headless import of the project.
2. Run GUT with reports.
3. Fail the pipeline on any error.

## Recommendations
- Use small scenes for tests.
- Test signals and critical states.
- Run in CI/CD when possible.

## CI/CD (GUT Headless)
- Run headless import before tests.
- Execute GUT via `gut_cmdln.gd`.
- Fail the pipeline if any test fails.
