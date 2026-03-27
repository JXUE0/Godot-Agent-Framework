#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-}"
INSTALL_MCP=false
VALIDATE=false

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "[GAF][Setup] Usage: ./scripts/setup_project.sh /path/to/project --install-mcp --validate"
  exit 1
fi

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-mcp) INSTALL_MCP=true ;;
    --validate) VALIDATE=true ;;
  esac
  shift
done

echo "[GAF][Setup] Project detected: $PROJECT_ROOT"

# Bash logic for AI rules
GAF_ROOT="$(dirname "$0")"
for rule in .cursorrules .clinerules; do
  SOURCE="$GAF_ROOT/../$rule"
  DEST="$PROJECT_ROOT/$rule"
  if [[ -f "$SOURCE" ]]; then
    echo "[GAF][Setup] Copying AI rules ($rule) to $PROJECT_ROOT"
    cp -f "$SOURCE" "$DEST"
  fi
done

# Copy GitHub Copilot instructions
COPILOT_SOURCE="$GAF_ROOT/../.github/copilot-instructions.md"
GITHUB_DEST="$PROJECT_ROOT/.github"
if [[ -f "$COPILOT_SOURCE" ]]; then
  mkdir -p "$GITHUB_DEST"
  echo "[GAF][Setup] Copying GitHub Copilot instructions to $GITHUB_DEST"
  cp -f "$COPILOT_SOURCE" "$GITHUB_DEST/copilot-instructions.md"
fi

if $INSTALL_MCP; then
  echo "[GAF][Setup] Installing MCP..."
  bash "$GAF_ROOT/install_mcp.sh" "$PROJECT_ROOT"
fi

if $VALIDATE; then
  bash "$(dirname "$0")/validate_project.sh"
fi

echo "[GAF][Setup] Completed"
