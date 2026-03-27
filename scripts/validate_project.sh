#!/usr/bin/env bash
set -euo pipefail

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "$FRAMEWORK_ROOT/.." && pwd)"

if [[ ! -f "$PROJECT_ROOT/project.godot" ]]; then
  echo "[GAF] project.godot no encontrado en $PROJECT_ROOT. Usando frameworkRoot como proyecto."
  PROJECT_ROOT="$FRAMEWORK_ROOT"
fi

mapfile -t STRUCTURE < <("$FRAMEWORK_ROOT/tools/structure_enforcer/validate.sh" "$PROJECT_ROOT" "$FRAMEWORK_ROOT")
mapfile -t ASSETS < <("$FRAMEWORK_ROOT/tools/asset_validator/validate.sh" "$PROJECT_ROOT" "$FRAMEWORK_ROOT")
FINDINGS=("${STRUCTURE[@]}" "${ASSETS[@]}")

REPORT_PATH="$FRAMEWORK_ROOT/docs/generated/validation-report.md"
"$FRAMEWORK_ROOT/tools/docs_generator/generate_report.sh" "$FRAMEWORK_ROOT" "$REPORT_PATH" "${FINDINGS[@]}"

ERRORS=()
WARNINGS=()
for f in "${FINDINGS[@]}"; do
  [[ "$f" == ERROR:* ]] && ERRORS+=("$f")
  [[ "$f" == WARN:* ]] && WARNINGS+=("$f")
 done

echo "[GAF] Validacion completada. Errors: ${#ERRORS[@]} | Warnings: ${#WARNINGS[@]}"
echo "[GAF] Reporte: $REPORT_PATH"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  exit 1
fi
