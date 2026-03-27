#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$1"

check() {
  local name="$1"
  local regex="$2"
  local replace="$3"
  local matches
  matches=$(rg -n "$regex" "$PROJECT_ROOT" --glob "*.gd" || true)
  if [[ -n "$matches" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      echo "ERROR: API deprecada '$name' en $line | Usar: $replace"
    done <<< "$matches"
  fi
}

check "yield()" "\\byield\\s*\\(" "await <signal>"
check "instance()" "\\binstance\\s*\\(" "instantiate()"
check "PackedScene.instance()" "PackedScene\\.instance\\s*\\(" "PackedScene.instantiate()"
check "connect(string)" "\\.connect\\s*\\(\\s*\"[^\"]+\"\\s*," "signal.connect(callable)"
check "TileMap node" "\\bTileMap\\b" "TileMapLayer"
check "YSort node" "\\bYSort\\b" "Node2D.y_sort_enabled"
check "VisibilityNotifier2D" "\\bVisibilityNotifier2D\\b" "VisibleOnScreenNotifier2D"
check "VisibilityNotifier3D" "\\bVisibilityNotifier3D\\b" "VisibleOnScreenNotifier3D"
