#!/usr/bin/env bash
set -euo pipefail

FRAMEWORK_ROOT="$1"
REPORT_PATH="$2"
shift 2
FINDINGS=("$@")

mkdir -p "$(dirname "$REPORT_PATH")"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

ERRORS=()
WARNS=()
for f in "${FINDINGS[@]}"; do
  [[ "$f" == ERROR:* ]] && ERRORS+=("$f")
  [[ "$f" == WARN:* ]] && WARNS+=("$f")
 done

{
  echo "# GAF Validation Report"
  echo ""
  echo "- Timestamp: $TIMESTAMP"
  echo "- Errors: ${#ERRORS[@]}"
  echo "- Warnings: ${#WARNS[@]}"
  echo ""
  echo "## Errors"
  for e in "${ERRORS[@]}"; do echo "$e"; done
  echo ""
  echo "## Warnings"
  for w in "${WARNS[@]}"; do echo "$w"; done
} > "$REPORT_PATH"
