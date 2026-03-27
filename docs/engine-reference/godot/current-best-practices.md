# Godot — Current Best Practices
Last verified: 2026-02-12
Engine: Godot 4.6

Practicas nuevas o cambiadas desde ~4.3. Esto complementa el conocimiento general del modelo.

## GDScript (4.5+)
- Variadicos con `...`.
- `@abstract` para clases/metodos abstractos.
- Backtracing disponible incluso en builds Release.

## Physics (4.6)
- Jolt es el motor 3D por defecto en proyectos nuevos.
- GodotPhysics3D sigue disponible para compatibilidad.
- Algunas props (ej. `HingeJoint3D.damp`) solo funcionan en GodotPhysics3D.

## Rendering (4.6)
- D3D12 por defecto en Windows.
- Glow antes del tonemapping.
- SSR mejorado.
- AgX tonemapper con white point y contrast.

## Rendering (4.5)
- Shader Baker para precompilar shaders.
- SMAA 1x como AA.
- Stencil buffer y mejoras en materiales (bent normal/specular occlusion).

## Accessibility (4.5+)
- Soporte de screen reader via AccessKit.
- Live translation preview en editor.
- FoldableContainer y recursive control disable.

## Animation (4.5+ / 4.6)
- BoneConstraint3D con modifiers (Aim/Copy/ConvertTransform).
- IK restaurado via `SkeletonModifier3D`.

## Resources (4.5+)
- Usar `duplicate_deep()` para copias profundas de recursos anidados.

## Navigation (4.5+)
- NavigationServer2D dedicado (no proxy de 3D).

## UI (4.6)
- Dual-focus (mouse/touch separado de teclado/gamepad).

## Editor Workflow (4.6)
- Docks flotantes, shortcuts nuevos y mejoras en Quick Open.

## Platform (4.5+)
- visionOS export.
- SDL3 para gamepads.
- Android: edge-to-edge, camera feed, 16KB pages.
- Linux: Wayland subwindow.
