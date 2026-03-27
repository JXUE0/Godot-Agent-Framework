# Godot UI — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- 4.6: Dual-focus (mouse/touch vs teclado).
- 4.5: FoldableContainer, recursive control disable, AccessKit.

## Patrones actuales
- Usar `tr()` para textos visibles.
- Probar foco con mouse y gamepad.

## Errores comunes
- Asumir que `grab_focus()` afecta mouse.
- Hardcodear strings sin `tr()`.
