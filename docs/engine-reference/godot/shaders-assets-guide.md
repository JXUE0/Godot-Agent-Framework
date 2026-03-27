# 🎨 GODOT 4.X — SHADERS & ASSETS GUIDE (GAF)
> [!IMPORTANT]
> **PIPELINE STANDARD:** This guide ensures all visual assets and shaders are performant, compatible, and optimized for Vulkan/VRAM usage.

## 🌈 SHADER DEVELOPMENT (GDSHADER)

- **Sintaxis Moderna:** Use `texture(sampler, uv)` instead of `texture2D()`. 
- **Modos de Renderizado:**
  - `render_mode blend_mix;` // Default for 2D/3D.
  - `render_mode unshaded;` // Performance boost for UI or simple flat styles.
  - `render_mode compatibility;` // Essential for GLES3 / WebGL support.
- **Built-in Global Variables:**
  - `TIME:` Access the system time for scrolling textures or wind effects.
  - `UV:` Current texture coordinate.
  - `COLOR / ALBEDO:` Target color for output.
- **Varyings:** Declare transfer variables at the file header to pass data from `vertex()` to `fragment()`.

## 📦 ASSET OPTIMIZATION (IMPORT PIPELINE)

- **Texture Formats (VRAM):**
  - **S3TC (**BPTC/DXT):** Default for Desktop (best performance/quality).
  - **ETC2 / ASTC:** Default for Mobile.
  - **Lossless (PNG/WEBP):** Use ONLY for pixel art or UI that requires 0 blur.
- **MipMaps:** ALWAYS enable for 3D textures to avoid moiré patterns and improve performance on distant objects.
- **Filters:**
  - `Nearest:` Pixel art style.
  - `Linear:` Smooth transitions (Standard 3D).
- **Normal Maps:** Ensure the "Normal Map" flag is checked in the Import tab for correct Z-axis calculation.

## 🏗️ 3D MODELS (FBX / GLB / OBJ)

- **Preferred Format:** **GLB / GLTF 2.0**. It's the most stable and fastest format for Godot 4.
- **LOD (Level of Detail):** Godot 4 generates LODs automatically on import. Ensure the Mesh isn't too high-poly at close range.
- **Materials:** Use `StandardMaterial3D` for 90% of your assets. Only switch to `ShaderMaterial` if you need custom logic (e.g., foliage wind, dynamic water).
- **Scale Check:** Keep your models at scale 1.0. Scaling nodes in the editor to -1 or extreme values can break physics and lighting calculation.

## 🖼️ 2D SPRITES & ATLASES

- **AtlasTextures:** For UI and large TileMaps, use `AtlasTexture` to combine multiple sprites into one draw call.
- **Texture Packing:** Use Godot's built-in SpritePacker or external tools (TexturePacker) for optimized mobile games.
- **Compression:** Avoid using uncompressed VRAM flags for UI elements unless they show visible artifacts.

---
*Created for Godot 4.3+ | Godot Agent Framework (GAF)*
