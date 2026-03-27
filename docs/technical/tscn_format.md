# TSCN Format — Basic Reference

## Key sections
1. **Header**
   - `[gd_scene load_steps=... format=3]`
2. **External resources**
   - `[ext_resource type="..." path="res://..." id="..." uid="..."]`
3. **Internal resources**
   - `[sub_resource type="..." id="..."]`
4. **Nodes**
   - `[node name="..." type="..." parent="..."]`
5. **Connections**
   - `[connection signal="..." from="..." to="..." method="..."]`

## Safe editing rules
- Do not modify UIDs unless needed.
- Keep resource order when possible.
- Use valid `res://` paths.
- Validate the scene afterwards.
