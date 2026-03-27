# Godot — Breaking Changes
Last verified: 2026-02-12

## 4.5 → 4.6 (Jan 2026 — HIGH)

| Subsystem | Change | Details |
|---|---|---|
| Physics | Jolt is default 3D engine | New projects use Jolt by default. Existing projects keep config. Some props (e.g., `HingeJoint3D.damp`) only work with GodotPhysics3D. |
| Rendering | Glow before tonemapping | Scene look may change. Adjust WorldEnvironment. |
| Rendering | D3D12 default on Windows | Previously Vulkan. Better driver compatibility. |
| Rendering | AgX tonemapper controls | Added white point and contrast. |
| Core | Quaternions initialize to identity | Previously zero. Minor but breaking. |
| UI | Dual focus system | Mouse/touch separate from keyboard/gamepad. |
| Animation | IK restored | CCDIK, FABRIK, Jacobian, Spline IK, TwoBoneIK via `SkeletonModifier3D`. |
| Editor | “Modern” theme default | Grayscale instead of blue. |
| Editor | New Select Mode | `v` selects, `q` is Transform Mode. |
| 2D | TileMapLayer rotates scene tiles | Scene tiles rotate like atlas tiles. |
| Localization | CSV plurals | No longer requires Gettext for plurals. |
| C# | Auto string extraction | Translation strings extracted automatically. |
| Plugins | New EditorDock | Specialized dock container. |

## 4.4 → 4.5 (Late 2025 — HIGH)

| Subsystem | Change | Details |
|---|---|---|
| GDScript | Variadics (`...`) | Functions accept arbitrary params. |
| GDScript | `@abstract` | Abstract classes/methods with enforcement. |
| GDScript | Backtracing in release | Detailed call stacks in release builds. |
| Rendering | Stencil buffer | Used for masking/portals. |
| Rendering | SMAA 1x | New AA option. |
| Rendering | Shader Baker | Shader precompilation. |
| Rendering | Bent normal / specular occlusion | Material features. |
| Accessibility | Screen reader | AccessKit integration. |
| Editor | Live translation preview | Preview translations in editor. |
| Physics | 3D interpolation re-architected | Now in SceneTree; API stable. |
| Animation | BoneConstraint3D + modifiers | Aim/Copy/ConvertTransform. |
| Resources | `duplicate_deep()` | Explicit deep copy. |
| Navigation | Dedicated NavigationServer2D | No longer 3D proxy. |
| UI | FoldableContainer | Accordion container. |
| UI | Recursive Control disable | Disable input across hierarchy. |
| Platform | visionOS export | New target. |
| Platform | SDL3 gamepad | Better cross‑platform support. |
| Platform | Android 16KB page | Required for Android 15+. |

## 4.3 → 4.4 (NEAR CUTOFF)

| Subsystem | Change | Details |
|---|---|---|
| Core | `FileAccess.store_*` returns `bool` | Previously `void`. |
| Core | `OS.execute_with_pipe` adds `blocking` | Optional param. |
| Core | `RegEx.compile/create_from_string` adds `show_error` | Optional param. |
| Rendering | `RenderingDevice.draw_list_begin` | Params removed + `breadcrumb` added. |
| Rendering | Shader texture types | `Texture2D` → `Texture`. |
| Particles | `.restart()` adds `keep_seed` | Optional param. |
| GUI | `RichTextLabel.push_meta` adds `tooltip` | Optional param. |
| GUI | `GraphEdit.connect_node` adds `keep_alive` | Optional param. |
