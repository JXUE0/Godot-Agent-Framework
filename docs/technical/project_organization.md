# Organizacion de Proyecto (Godot)

## Principios (basado en docs oficiales)
- Separar contenido del motor y del proyecto.
- Evitar carpetas gigantes con miles de archivos.
- Usar `.gdignore` cuando una carpeta no debe importarse.

## Estructuras comunes
### Por feature (recomendado en proyectos grandes)
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

### Por tipo (proyectos pequenos)
```
res://
  scenes/
  scripts/
  textures/
```

## Reglas de naming
- Archivos en `snake_case`.
- Escenas en `PascalCase`.

## Uso de .gdignore
- Colocar `.gdignore` en carpetas de build o assets temporales.
- Ejemplo: `build/` o `temp/`.
