# 🤖 Godot Agent Framework (GAF) - (ES)

![Godot Engine](https://img.shields.io/badge/Godot-4.3+-blue?logo=godot-engine&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Native_Bridge-green?logo=node.js)
![MCP](https://img.shields.io/badge/Protocol-MCP_JSON--RPC-orange)

[English](../../README.md)

---

El **Godot Agent Framework (GAF)** es un ecosistema de alto rendimiento, seguro y completo diseñado para potenciar Agentes de IA en el desarrollo autónomo de videojuegos. Establece un canal de comunicación robusto y bidireccional entre los modelos de IA y la API del Editor de Godot mediante el **Model Context Protocol (MCP)**.

## 🏁 Inicio Rápido y Consejos

Si eres un humano configurando esto por primera vez:
1. **Clona este repositorio** dentro de la carpeta de tu proyecto de Godot.
2. **Ejecuta el instalador:** Ejecuta `scripts/setup_project.ps1` (PowerShell) para inyectar el addon.
3. **Activa el Plugin:** Abre Godot, ve a `Project Settings > Plugins` y activa `gaf_sync`.
4. **Configura tu IA:** Sigue la [Configuración del MCP](#-instalación-y-configuración-del-mcp) más abajo.

> [!TIP]
> **💬 Cómo empezar:** Solo dile a tu IA: *"Usa las herramientas de **gaf-sync** para analizar mi escena actual de Godot y la configuración del proyecto"* para comenzar.

---

## 💡 Consejos Pro para Programación con IA

> [!TIP]
> **⌘ La Red de Seguridad `Undo`:** Todas las acciones de IA que modifican el SceneTree están envueltas en operaciones nativas de Godot `UndoRedo`. ¡Si la IA se equivoca, simplemente haz clic en el **Editor de Godot** y pulsa `Ctrl + Z`!

> [!IMPORTANT]
> **📦 El Control de Versiones es el Rey:** Haz commit de tu proyecto de Godot en Git siempre **antes** de pedir a la IA un refactorizado arquitectónico masivo. `git add . && git commit -m "pre-ai-work"`.

> [!NOTE]
> **🤖 Roles de Agentes:** Dirígete a la IA específicamente para activar comportamientos de especialista. Por ejemplo: *"Lee tu perfil de Technical Artist y arregla los anclajes de mi UI"*.

> [!INFO]
> **⚡ Sin dependencias NPM:** El bridge de Node.js no utiliza dependencias externas. No requiere ninguna instalación molesta de `npm install`.

---

## 📡 Instalación y Configuración del MCP

Para que la IA use estas herramientas, debes registrar el **GAF-Sync Bridge** en tu IDE de IA.

### 1. Cursor IDE (Estándar)
- Ve a `Settings > Cursor Settings > MCP`.
- Añade un nuevo servidor MCP:
  - **Nombre:** `gaf-sync`
  - **Tipo:** `command`
  - **Comando:** `node "[Ruta_Absoluta_Al_GAF]\tools\mcp\gaf_bridge.js"`

### 2. Cline / Roo-Code / Continue (VSCode)
- Haz clic en el icono de **Consola MCP** (o Settings > MCP en Continue).
- Edita tu `mcp_settings.json` o equivalente:
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

### 3. Windsurf (Codeium)
- Abre el archivo `mcp_config.json` de Windsurf.
- Añade la configuración de `gaf-sync` usando el mismo formato JSON anterior.

### 4. Claude Desktop
- Abre `%APPDATA%\Claude\claude_desktop_config.json`.
- Añade la entrada `gaf-sync` bajo `mcpServers`.

---

## 🚀 Entornos de IA Soportados
El **GAF** se basa en el estándar universal de **MCP**, lo que lo hace compatible con las herramientas de programación de IA más avanzadas:
- **Cursor:** El IDE nativo de IA líder del mercado.
- **VSCode (Cline / Roo-Code / Continue):** Las extensiones de agentes más populares.
- **Windsurf:** El nuevo IDE basado en "Flujos" de Codeium.
- **Claude Desktop:** La aplicación oficial de Anthropic.

---

## 🧠 Especialistas de IA
El ecosistema GAF se basa en cuatro perfiles especializados (en `agents/`). Todos tienen acceso al arsenal de herramientas, pero con enfoques distintos:

- **🎩 Producer:** El orquestador. Analiza la intención del usuario, gestiona el roadmap y delega en especialistas.
- **💻 Lead Engineer:** El arquitecto. Responsable de GDScript, la estructura de la escena y la lógica central.
- **🎨 Technical Artist:** El experto visual. Maneja anclajes de UI, Shaders, Animación y Diseño de Niveles.
- **🔬 QA Engineer:** El auditor. Prueba la estabilidad, audita el tipado y usa herramientas de ejecución para estresar mecánicas.

---

## 📂 Estructura del Framework
```text
Tu-Proyecto-Godot/
├── addons/
│   └── gaf_sync/           # 🔌 Addon de Godot: Motor de Sincronización.
├── Godot-Agent-Framework/  # 📦 Repositorio Monorepo:
│   ├── agents/             # 🧠 Perfiles de Agentes especializados.
│   ├── docs/               # 📜 Guías y Manuales de Buenas Prácticas GAF.
│   ├── scripts/            # ⚙️ Instaladores (setup_project.ps1).
│   └── tools/mcp/          # Bridge (gaf_bridge.js).
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
