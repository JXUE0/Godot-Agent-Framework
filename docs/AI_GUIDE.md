# AI_GUIDE.md

## 1. Flujo obligatorio para cualquier IA
1. Leer este archivo.
2. Seleccionar un rol en gents/.\n3. Revisar docs/engine-reference/godot/README.md antes de sugerir APIs.
4. Revisar `docs/PROJECT_STRUCTURE.md` y `docs/GODOT_BEST_PRACTICES.md`.
5. Proponer un plan.
5. Ejecutar tareas con validación.
7. Documentar cambios.
8. Notificar a `agents/producer.md`.

## 2. Reglas estrictas
- No modificar estructura sin consultar al Lead Engineer.
- No crear escenas fuera de carpetas definidas.
- Documentar siempre.
- Validar assets y scripts antes de entregar.
- Seguir convenciones GDScript.

## 3. Integración con addons (ej. godot_mcp)
Este framework NO copia addons por defecto. Si el proyecto ya tiene `addons/godot_mcp`, la IA debe:
- Detectar el addon.
- Usarlo como herramienta disponible.
- No modificarlo sin aprobación explícita.

## 4. Scripts importantes
- `scripts/setup_project.*` prepara el entorno.
- `scripts/validate_project.*` valida estructura y estándares.
- `scripts/generate_docs.*` genera documentación técnica.

## 5. Colaboración
- Lead Engineer define la arquitectura.
- Architecture Strategist valida estructura.
- QA valida cambios.
- Producer coordina entregas.

\n\n## 6. Reglas y hooks\n- Reglas base en ules/common/\n- Reglas Godot en ules/gdscript/\n- Hooks en hooks/ (profiles minimal/standard/strict)\n
