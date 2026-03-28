# Contributing to Godot Agent Framework (GAF)

First off, thank you for considering contributing to GAF! This project aims to bring professional AI pair-programming to Godot 4.3+, and it's developers like you that help the open-source community thrive.

## Ways to Contribute
- **Improve Documentation**: Better `.md` rules, clearer agent setups, or tutorial fixes.
- **Add Native MCP Tools**: Extending `gaf_handler.gd` to perform new Godot Editor manipulations.
- **Bug Fixes**: Security checks, memory optimizations, edge-cases.
- **Agent Prompts**: Proposing new expert personas in the `agents/` folder.

## How to Contribute (Workflow)

1. **Fork the Repository**: Start by forking this repository to your GitHub account.
2. **Clone Locally**: Clone your fork to your local workspace.
3. **Branch Out**: Create a new branch for your feature or bug fix (`git checkout -b feature/awesome-new-tool`).
4. **Develop and Test**: Make your changes. Ensure the Node.js bridge (`tools/mcp/gaf_bridge.js`) and Godot Add-on (`addons/gaf_sync`) run smoothly and conform to the pure TCP architecture.
5. **Commit your Changes**: Use clear, descriptive commit messages (e.g., `feat: added AI tool for shader manipulation` or `fix: corrected UndoRedo action logic`).
6. **Push and Pull Request**: Push your branch to GitHub and create a Pull Request against our `main` branch.

## Architecture & Code Guidelines

- **Zero NPM Dependencies**: The Node bridge (`gaf_bridge.js`) must strictly rely on native Node.js modules (`net`, `fs`). Do **not** inject `npm install` requirements or external wrapper libraries.
- **Godot 4.3+ Standards**: All GDScript must be statically typed (e.g., `var strength: float = 10.0`) and avoid deprecated API calls.
- **Editor Security**: Destructive actions in Godot must always be wrapped in `EditorUndoRedoManager` to allow humans to reverse AI mistakes safely.
- **Prompt Engineering**: When modifying `.md` files in `agents/`, keep the tone direct, professional, and strictly formatted. Do not add conversational fluff to the agent instructions.

We will review your PR as quickly as possible. Happy coding!
