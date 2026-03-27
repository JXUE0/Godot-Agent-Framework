# CI con GUT (GitHub Actions)

Ejemplo basico para ejecutar GUT en headless.

```yaml
name: godot-gut

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Download Godot
        run: |
          wget -O godot.zip https://downloads.tuxfamily.org/godotengine/4.2.2/Godot_v4.2.2-stable_linux.x86_64.zip
          unzip godot.zip
          chmod +x Godot_v4.2.2-stable_linux.x86_64
          mv Godot_v4.2.2-stable_linux.x86_64 godot

      - name: Headless import
        run: |
          ./godot --headless --path . --editor --quit

      - name: Run GUT
        run: |
          ./godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gexit
```

Notas:
- Ajusta la version de Godot a la usada por tu proyecto.
- Requiere tener GUT instalado en `addons/gut`.
