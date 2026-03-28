# 🤖 Godot Agent Framework (GAF) - V1.5.0 (ES)

![Godot Engine](https://img.shields.io/badge/Godot-4.3+-blue?logo=godot-engine&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Native_Bridge-green?logo=node.js)
![MCP](https://img.shields.io/badge/Protocol-MCP_JSON--RPC-orange)

[English](README.md)

---

El **Godot Agent Framework (GAF)** es un ecosistema de alto rendimiento, seguro y completo diseñado para potenciar Agentes de IA en el desarrollo autónomo de videojuegos. Establece un canal de comunicación robusto y bidireccional entre los modelos de IA y la API del Editor de Godot.

## 📡 Instalación y Configuración del MCP

Para que la IA use estas herramientas, debes registrar el **GAF-Sync Bridge** en tu IDE de IA accesible.

### 1. Cursor IDE
- Ve a `Settings > Cursor Settings > MCP`.
- Añade un nuevo servidor MCP:
  - **Nombre:** `gaf-sync`
  - **Tipo:** `command`
  - **Comando:** `node "[Ruta_Absoluta_Al_GAF]\tools\mcp\gaf_bridge.js"`

### 2. Cline / Roo-Code (VSCode)
- Haz clic en el icono de **Consola MCP** (las barras junto al prompt).
- Edita tu `mcp_settings.json`:
```json
{
  "mcpServers": {
    "gaf-sync": {
      "command": "node",
      "args": ["[Ruta_Absoluta_Al_GAF]\\tools\\mcp\\gaf_bridge.js"]
    }
  }
}
```

---

## 📂 Estructura del Framework
```text
Tu-Proyecto-Godot/
├── addons/
│   └── gaf_sync/           # 🔌 Addon de Godot
├── Godot-Agent-Framework/  # 📦 Repositorio Monorepo:
│   ├── agents/             # 🧠 Personajes Especialistas de IA
│   ├── docs/               # 📜 Reglas y Guías
│   ├── scripts/            # ⚙️ Instaladores (setup_project.ps1)
│   └── tools/mcp/          # Bridge (gaf_bridge.js)
```

## 🛠️ Arsenal de Herramientas (19+ Nativas)
- **Manipulación de Escenas:** Crear, borrar, duplicar, renombrar y re-parentar nodos.
- **Scripting:** Leer y recargar GDScripts al instante en el Editor.
- **Tipado Seguro:** Parser inteligente para `Vector2/3`, `Color`, `Rect2`, `Cuaterniones`.
- **Lógica:** Conectar señales y actualizar propiedades de forma nativa.
- **Undo/Redo:** Todo cambio en la escena soporta el Deshacer de Godot (`Ctrl+Z`).

## 📡 Primitivas de Protocolo Avanzadas
- **Recursos (RAG):** Carga automática de `InputMap` y `Autoloads` para la IA.
- **Prompts:** Workflows pre-construidos para Máquinas de Estado y Auditorías de Rendimiento.

---

### 📜 Licencia
Godot Agent Framework (GAF) se distribuye bajo la **Licencia MIT**.
Copyright (c) 2026 JXUE0.
