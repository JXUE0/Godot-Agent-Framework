# Project Organization (Godot)

## Principles (official docs)
- Separate engine and project content.
- Avoid giant folders with thousands of files.
- Use `.gdignore` to exclude folders from import.

## Common structures
### By feature (recommended for large projects)
```
res://
  player/
    player.tscn
    player.gd
    player.png
  enemy/
    enemy.tscn
    enemy.gd
    enemy.png
```

### By type (small projects)
```
res://
  scenes/
  scripts/
  textures/
```

## Naming rules
- Files in `snake_case`.
- Scenes in `PascalCase`.

## Using .gdignore
- Place `.gdignore` in build/temp folders.
- Example: `build/` or `temp/`.
