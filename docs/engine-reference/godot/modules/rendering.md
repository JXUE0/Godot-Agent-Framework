# Godot Rendering — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- 4.6: D3D12 default en Windows, glow antes del tonemapping, AgX, SSR mejorado.
- 4.5: Shader Baker, SMAA, stencil buffer.
- 4.4: `Texture2D` → `Texture` en shaders.

## Patrones actuales
- Usar `Compositor` para post-proceso.
- Elegir AA segun plataforma (SMAA/FXAA/TAA).

## Errores comunes
- Asumir Vulkan default en Windows.
- Usar `Texture2D` en uniformes de shader.
