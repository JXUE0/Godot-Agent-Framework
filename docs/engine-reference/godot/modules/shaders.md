# Godot Shaders — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- `Texture2D` → `Texture` in shaders (4.4).
- Shader Baker precompilation (4.5).

## Pattern
```glsl
shader_type spatial;
uniform sampler2D albedo_tex : source_color;
```

## Common pitfalls
- Using `Texture2D` in uniforms.
- Ignoring Shader Baker in large projects.
