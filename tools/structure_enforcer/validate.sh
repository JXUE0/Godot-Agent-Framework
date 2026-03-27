#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"
FRAMEWORK_ROOT="$2"
PROJECT_FILE="$PROJECT_ROOT/project.godot"
FRAMEWORK_DIR="$PROJECT_ROOT/godot-agent-framework"
TEMPLATES_DIR="$FRAMEWORK_ROOT/tools/scene_templates"

if [[ ! -f "$PROJECT_FILE" ]]; then
  echo "ERROR: No se encontro project.godot en $PROJECT_ROOT"
fi

if [[ ! -d "$FRAMEWORK_DIR" ]]; then
  echo "ERROR: No se encontro godot-agent-framework/ en $PROJECT_ROOT"
fi

while IFS= read -r -d '' file; do
  if [[ "$file" != "$TEMPLATES_DIR"* ]]; then
    echo "WARN: Escena dentro del framework fuera de scene_templates: $file"
  fi

done < <(find "$FRAMEWORK_ROOT" -type f -name "*.tscn" -print0)
