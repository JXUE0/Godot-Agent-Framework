# Godot Rendering — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- 4.6: D3D12 default on Windows, glow before tonemapping, AgX, SSR.
- 4.5: Shader Baker, SMAA, stencil buffer.
- 4.4: `Texture2D` → `Texture` in shaders.

## Pattern
- Use `Compositor` for post‑processing.
- Choose AA per platform (SMAA/FXAA/TAA).

## Common pitfalls
- Assuming Vulkan default on Windows.
- Using `Texture2D` in shader uniforms.
