#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"
FRAMEWORK_ROOT="$2"

EXCLUDED_DIRS=(".godot" ".import" ".git" "node_modules" "bin" "obj")
TEMP_EXTS=(".tmp" ".bak" ".swp" ".old" ".log")
HEAVY_EXTS=(".psd" ".blend" ".kra" ".xcf" ".aep")
ALLOWED_TEMP_DIRS=("temp" "tmp" "_temp" ".temp" "$FRAMEWORK_ROOT/temp")

is_excluded() {
  local path="$1"
  for d in "${EXCLUDED_DIRS[@]}"; do
    [[ "$path" == *"/$d/"* ]] && return 0
  done
  return 1
}

in_allowed_temp() {
  local path="$1"
  for d in "${ALLOWED_TEMP_DIRS[@]}"; do
    [[ "$path" == *"$d/"* ]] && return 0
  done
  return 1
}

while IFS= read -r -d '' file; do
  is_excluded "$file" && continue
  name="$(basename "$file")"
  ext=".${name##*.}"
  [[ "$name" == *.* ]] || ext=""

  if [[ "$name" =~ [[:space:]] ]]; then
    echo "ERROR: Espacios en nombre de archivo: $file"
  fi

  if [[ "$name" =~ [A-Z] ]]; then
    echo "WARN: Mayusculas en nombre de archivo: $file"
  fi

  for te in "${TEMP_EXTS[@]}"; do
    if [[ "$ext" == "$te" ]]; then
      if in_allowed_temp "$file"; then
        echo "WARN: Archivo temporal en carpeta temporal: $file"
      else
        echo "ERROR: Archivo temporal fuera de carpeta temporal: $file"
      fi
    fi
  done

  for he in "${HEAVY_EXTS[@]}"; do
    if [[ "$ext" == "$he" ]]; then
      echo "WARN: Archivo pesado/fuente detectado (revisar): $file"
    fi
  done

done < <(find "$PROJECT_ROOT" -type f -print0)
