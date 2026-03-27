# Godot UI — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Changes
- 4.6: Dual focus system.
- 4.5: FoldableContainer, recursive control disable, AccessKit.

## Pattern
- Use `tr()` for visible text.
- Test focus with mouse and gamepad.

## Common pitfalls
- Assuming `grab_focus()` affects mouse.
- Hardcoding strings without `tr()`.
