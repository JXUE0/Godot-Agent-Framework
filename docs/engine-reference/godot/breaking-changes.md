# Godot — Breaking Changes
Last verified: 2026-02-12

Cambios entre versiones, enfocado en cambios post-cutoff (4.4+).

## 4.5 → 4.6 (Jan 2026 — POST-CUTOFF, HIGH RISK)

| Subsystem | Change | Details |
|---|---|---|
| Physics | Jolt es el motor 3D por defecto | Nuevos proyectos usan Jolt automaticamente. Proyectos existentes conservan su configuracion. Algunas props como `HingeJoint3D.damp` solo funcionan con GodotPhysics3D. |
| Rendering | Glow ahora procesa ANTES del tonemapping | El look de escenas con glow puede cambiar. Ajustar en WorldEnvironment. |
| Rendering | D3D12 por defecto en Windows | Antes era Vulkan. Mejor compatibilidad con drivers. |
| Rendering | AgX tonemapper con nuevos controles | Se agregan white point y contrast. |
| Core | Quaternions inicializan a identidad | Antes era cero; impacto bajo pero tecnicamente breaking. |
| UI | Sistema de doble focus | Mouse/touch separado de teclado/gamepad. Feedback visual distinto. |
| Animation | IK restaurado | CCDIK, FABRIK, Jacobian, Spline IK, TwoBoneIK via `SkeletonModifier3D`. |
| Editor | Tema “Modern” por defecto | Grayscale en lugar de azul. Se puede volver a Classic. |
| Editor | Nuevo “Select Mode” | Tecla `v` para seleccionar; `q` ahora es Transform Mode. |
| 2D | TileMapLayer rota scene tiles | Los scene tiles ahora pueden rotarse como atlas tiles. |
| Localization | CSV con plurales | Ya no requiere Gettext para plurales. |
| C# | Extraccion automatica de strings | Strings de traduccion se extraen desde C# automaticamente. |
| Plugins | Nuevo EditorDock | Contenedor especializado para docks de plugins. |

## 4.4 → 4.5 (Late 2025 — POST-CUTOFF, HIGH RISK)

| Subsystem | Change | Details |
|---|---|---|
| GDScript | Variadicos (`...`) | Funciones pueden recibir parametros arbitrarios. |
| GDScript | `@abstract` | Clases/metodos abstractos con enforcement. |
| GDScript | Backtracing en release | Call stacks detallados disponibles. |
| Rendering | Stencil buffer | Para masking/portales. |
| Rendering | SMAA 1x | Nueva opcion AA. |
| Rendering | Shader Baker | Precompilacion de shaders. |
| Rendering | Bent normal / specular occlusion | Nuevas features de materiales. |
| Accessibility | Screen reader | Integracion con AccessKit. |
| Editor | Live translation preview | Previsualizacion en distintos idiomas. |
| Physics | Interpolacion 3D re-arquitectada | Ahora en SceneTree; API estable. |
| Animation | BoneConstraint3D y nuevos modifiers | Aim/Copy/ConvertTransform. |
| Resources | `duplicate_deep()` | Copia profunda explicita. |
| Navigation | Server 2D dedicado | Ya no proxy del 3D. |
| UI | FoldableContainer | Contenedor tipo acordeon. |
| UI | Recursive Control disable | Deshabilita input en jerarquias completas. |
| Platform | visionOS export | Nuevo target. |
| Platform | SDL3 gamepad | Mejor soporte multiplataforma. |
| Platform | Android 16KB page | Requerido para Android 15+. |

## 4.3 → 4.4 (Mid 2025 — NEAR CUTOFF, VERIFY)

| Subsystem | Change | Details |
|---|---|---|
| Core | `FileAccess.store_*` devuelve `bool` | Antes `void`. |
| Core | `OS.execute_with_pipe` agrega `blocking` | Nuevo parametro opcional. |
| Core | `RegEx.compile/create_from_string` agrega `show_error` | Nuevo parametro opcional. |
| Rendering | `RenderingDevice.draw_list_begin` | Parametros removidos y `breadcrumb` agregado. |
| Rendering | Tipos de texturas en shader | `Texture2D` cambia a `Texture`. |
| Particles | `.restart()` agrega `keep_seed` | Parametro opcional. |
| GUI | `RichTextLabel.push_meta` agrega `tooltip` | Parametro opcional. |
| GUI | `GraphEdit.connect_node` agrega `keep_alive` | Parametro opcional. |

## 4.2 → 4.3 (In Training Data — LOW RISK)

| Subsystem | Change | Details |
|---|---|---|
| Animation | `Skeleton3D.add_bone` retorna `int32` | Antes `void`. |
| Animation | `bone_pose_updated` → `skeleton_updated` | Renombrado. |
| TileMap | `TileMapLayer` reemplaza `TileMap` | Un nodo por layer. |
| Navigation | `NavigationRegion2D` | Remueve `avoidance_layers`, `constrain_avoidance`. |
| Editor | `EditorSceneFormatImporterFBX` renombrado | Ahora `EditorSceneFormatImporterFBX2GLTF`. |
| Animation | AnimationMixer base class | AnimationPlayer/Tree extienden AnimationMixer. |
