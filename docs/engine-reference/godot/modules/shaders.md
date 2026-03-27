# Godot Shaders — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- `Texture2D` -> `Texture` en shaders (4.4).
- Shader Baker para precompilar (4.5).

## Patrones actuales
```glsl
shader_type spatial;
uniform sampler2D albedo_tex : source_color;
```

## Errores comunes
- Usar `Texture2D` en uniformes.
- Ignorar Shader Baker en proyectos grandes.
