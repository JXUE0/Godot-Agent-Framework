# Formato TSCN — Referencia Basica

Este documento describe la estructura minima del formato TSCN para edicion segura.

## Secciones clave
1. **Encabezado**
   - `[gd_scene load_steps=... format=3]`
2. **Recursos externos**
   - `[ext_resource type="..." path="res://..." id="..." uid="..."]`
3. **Recursos internos**
   - `[sub_resource type="..." id="..."]`
4. **Nodos**
   - `[node name="..." type="..." parent="..."]`
5. **Conexiones**
   - `[connection signal="..." from="..." to="..." method="..."]`

## Reglas de edicion segura
- No modificar UIDs sin necesidad.
- Mantener el orden de recursos si es posible.
- Usar rutas `res://` validas.
- Validar la escena al finalizar.
