# Godot — Current Best Practices
Last verified: 2026-02-12 | Engine: Godot 4.6

## GDScript (4.5+)
- Variadics with `...`.
- `@abstract` for abstract classes/methods.
- Backtracing in release builds.

## Physics (4.6)
- Jolt is default 3D engine for new projects.
- GodotPhysics3D remains available for compatibility.
- Some props (e.g., `HingeJoint3D.damp`) only work with GodotPhysics3D.

## Rendering (4.6)
- D3D12 default on Windows.
- Glow before tonemapping.
- AgX tonemapper with white point and contrast.

## Rendering (4.5)
- Shader Baker for precompilation.
- SMAA 1x AA.
- Stencil buffer, bent normal/specular occlusion.

## Accessibility (4.5+)
- Screen reader via AccessKit.
- Live translation preview.
- FoldableContainer and recursive control disable.

## Animation (4.5+ / 4.6)
- BoneConstraint3D modifiers.
- IK restored via `SkeletonModifier3D`.

## Resources (4.5+)
- Use `duplicate_deep()` for deep copies.

## Navigation (4.5+)
- Dedicated NavigationServer2D.

## UI (4.6)
- Dual focus system (mouse/touch vs keyboard/gamepad).

## Editor workflow (4.6)
- Floating docks and shortcut updates.
