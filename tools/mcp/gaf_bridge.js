#!/usr/bin/env node
const net = require('net');

/**
 * GAF-SYNC BRIDGE V1.4.0 (PURE TCP & NATIVE MCP COMPLIANT)
 * Protocol: MCP over STDIO -> TCP / JSON-RPC 2.0
 * Port: 1342
 * Security: Localhost-Only (127.0.0.1)
 * Dependencies: None (Pure Node.js)
 */

const PORT = 1342;
const HOST = '127.0.0.1';
let godotClient = null;
let nextId = 1;
const pendingRequests = new Map();

// --- MCP Server Setup ---
const SERVER_NAME = "gaf-sync";
const SERVER_VERSION = "1.5.0";

// Define the tools available in Godot
const GAF_TOOLS = [
    {
        name: "get_editor_state",
        description: "Get the current state of the Godot Editor, including active scene and play status.",
        inputSchema: { type: "object", properties: {}, required: [] }
    },
    {
        name: "get_scene_structure",
        description: "Get the full node tree structure of the currently edited scene.",
        inputSchema: { type: "object", properties: {}, required: [] }
    },
    {
        name: "create_node",
        description: "Create a new Godot node in the active scene.",
        inputSchema: {
            type: "object",
            properties: {
                type: { type: "string", description: "Node class type (e.g. 'Node2D', 'Sprite2D', 'Node')." },
                name: { type: "string", description: "Name of the new node." },
                parent: { type: "string", description: "Path to the parent node. Leave empty to add to the scene root." }
            },
            required: ["type", "name"]
        }
    },
    {
        name: "edit_script",
        description: "Replace the entire content of a GDScript file and reload it in the editor.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Resource path to the script (e.g. 'res://player.gd')." },
                content: { type: "string", description: "The new full GDScript source code." }
            },
            required: ["path", "content"]
        }
    },
    {
        name: "execute_editor_script",
        description: "Execute arbitrary GDScript code in the editor context.",
        inputSchema: {
            type: "object",
            properties: {
                code: { type: "string", description: "GDScript code block. Must be valid script logic to run." }
            },
            required: ["code"]
        }
    },
    {
        name: "delete_node",
        description: "Delete a node from the active scene.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Relative path to node to delete. Cannot delete root." }
            },
            required: ["path"]
        }
    },
    {
        name: "update_property",
        description: "Update a property on a node.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to node (use '.' for root)." },
                property: { type: "string", description: "Property name (e.g. 'position')." },
                value: { description: "New value (auto-cast by Godot)." }
            },
            required: ["path", "property", "value"]
        }
    },
    {
        name: "read_script",
        description: "Read the full source code of a GDScript.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Resource path (e.g. 'res://main.gd')." }
            },
            required: ["path"]
        }
    },
    {
        name: "duplicate_node",
        description: "Duplicate an existing node in the scene tree.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node to duplicate." }
            },
            required: ["path"]
        }
    },
    {
        name: "rename_node",
        description: "Rename a node in the scene tree.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node." },
                new_name: { type: "string", description: "The new name for the node." }
            },
            required: ["path", "new_name"]
        }
    },
    {
        name: "reparent_node",
        description: "Move a node to a different parent (reparent).",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node to move." },
                new_parent_path: { type: "string", description: "Path to the new parent node." }
            },
            required: ["path", "new_parent_path"]
        }
    },
    {
        name: "connect_signal",
        description: "Connect a signal from a source node to a target node's method.",
        inputSchema: {
            type: "object",
            properties: {
                source_path: { type: "string", description: "Path to the node emitting the signal." },
                signal_name: { type: "string", description: "Name of the signal (e.g. 'pressed')." },
                target_path: { type: "string", description: "Path to the node receiving the signal." },
                method_name: { type: "string", description: "Name of the target method." }
            },
            required: ["source_path", "signal_name", "target_path", "method_name"]
        }
    },
    {
        name: "disconnect_signal",
        description: "Disconnect a signal between two nodes.",
        inputSchema: {
            type: "object",
            properties: {
                source_path: { type: "string", description: "Path to the node emitting the signal." },
                signal_name: { type: "string", description: "Name of the signal." },
                target_path: { type: "string", description: "Path to the node receiving the signal." },
                method_name: { type: "string", description: "Name of the target method." }
            },
            required: ["source_path", "signal_name", "target_path", "method_name"]
        }
    },
    {
        name: "get_node_properties",
        description: "Get detailed properties of a specific node, including type and values.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node." }
            },
            required: ["path"]
        }
    },
    {
        name: "instantiate_scene",
        description: "Instantiate a saved scene (.tscn) into the current scene as a child of a node.",
        inputSchema: {
            type: "object",
            properties: {
                parent_path: { type: "string", description: "Path to the parent node. Root if empty." },
                scene_path: { type: "string", description: "Resource path to the .tscn file." },
                instance_name: { type: "string", description: "Optional custom name for the new instance." }
            },
            required: ["parent_path", "scene_path"]
        }
    },
    {
        name: "save_scene",
        description: "Save the current active scene to disk.",
        inputSchema: {
            type: "object",
            properties: {},
            required: []
        }
    },
    {
        name: "open_scene",
        description: "Open a scene (.tscn) in the Godot Editor.",
        inputSchema: {
            type: "object",
            properties: {
                scene_path: { type: "string", description: "Resource path to the .tscn file." }
            },
            required: ["scene_path"]
        }
    },
    {
        name: "play_scene",
        description: "Run the current active scene in the engine.",
        inputSchema: {
            type: "object",
            properties: {},
            required: []
        }
    },
    {
        name: "get_project_settings",
        description: "Get the value of a specific project setting, or a list of all custom settings if no property is provided.",
        inputSchema: {
            type: "object",
            properties: {
                property: { type: "string", description: "Optional. Setting path (e.g. 'display/window/size/viewport_width')." }
            },
            required: []
        }
    },
    {
        name: "search_files",
        description: "Search for files in the project directory (res://) by extension or name.",
        inputSchema: {
            type: "object",
            properties: {
                extension: { type: "string", description: "Optional. File extension to filter by (e.g. '.tscn', '.gd')." },
                query: { type: "string", description: "Optional. Text that the filename must contain." }
            },
            required: []
        }
    },
    {
        name: "get_selected_nodes",
        description: "Get the paths of the nodes currently selected by the user in the Godot Editor.",
        inputSchema: {
            type: "object",
            properties: {},
            required: []
        }
    },
    {
        name: "set_selected_nodes",
        description: "Change the Godot Editor selection to specific nodes.",
        inputSchema: {
            type: "object",
            properties: {
                paths: { type: "array", items: { type: "string" }, description: "Array of node paths to select." }
            },
            required: ["paths"]
        }
    },
    {
        name: "add_node_group",
        description: "Add a node to a specific group.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node." },
                group_name: { type: "string", description: "Name of the group." }
            },
            required: ["path", "group_name"]
        }
    },
    {
        name: "remove_node_group",
        description: "Remove a node from a specific group.",
        inputSchema: {
            type: "object",
            properties: {
                path: { type: "string", description: "Path to the node." },
                group_name: { type: "string", description: "Name of the group." }
            },
            required: ["path", "group_name"]
        }
    },
    {
        name: "stop_scene",
        description: "Stop the running scene.",
        inputSchema: {
            type: "object",
            properties: {},
            required: []
        }
    }
];

// Send JSON-RPC response to stdout (MCP Client)
function sendMCPResponse(id, result, error = null) {
    const msg = { jsonrpc: "2.0", id };
    if (error) {
        msg.error = error;
    } else {
        msg.result = result;
    }
    process.stdout.write(JSON.stringify(msg) + '\n');
}

// TCP Server acting as client to Godot (Bridge)
const server = net.createServer((socket) => {
    if (socket.remoteAddress !== '127.0.0.1' && socket.remoteAddress !== '::1') {
        console.error(`GAF-Security: Unauthorized connection attempt from ${socket.remoteAddress}`);
        socket.destroy();
        return;
    }

    console.error('GAF-Sync Bridge: Godot Editor connected successfully (TCP).');
    godotClient = socket;

    let godotBuffer = '';
    socket.on('data', (data) => {
        godotBuffer += data.toString();
        let scanIndex;
        while ((scanIndex = godotBuffer.indexOf('\n')) !== -1) {
            const msgText = godotBuffer.slice(0, scanIndex).trim();
            godotBuffer = godotBuffer.slice(scanIndex + 1);
            if (!msgText) continue;
            
            try {
                const message = JSON.parse(msgText);
                if (message.id !== undefined && pendingRequests.has(message.id)) {
                    const { resolve } = pendingRequests.get(message.id);
                    pendingRequests.delete(message.id);
                    resolve(message);
                }
            } catch (e) {
                console.error('GAF-Sync Bridge: Error parsing JSON data from Godot Editor:', e.message);
            }
        }
    });

    socket.on('close', () => {
        console.error('GAF-Sync Bridge: Godot Editor disconnected.');
        godotClient = null;
    });

    socket.on('error', (err) => {
        console.error('GAF-Sync Bridge: Socket error:', err.message);
    });
});

server.listen(PORT, HOST, () => {
    console.error(`GAF-Sync Bridge: Listening on TCP ${HOST}:${PORT}`);
    console.error('Status: Localhost-Only Security Active + Native MCP Mode (Professional Standard)');
});

/**
 * MCP HANDLER (STDIO Interface)
 */
let messageBuffer = '';
process.stdin.on('data', async (data) => {
    messageBuffer += data.toString();
    
    // Process all full lines in the buffer
    let scanIndex;
    while ((scanIndex = messageBuffer.indexOf('\n')) !== -1) {
        const line = messageBuffer.slice(0, scanIndex).trim();
        messageBuffer = messageBuffer.slice(scanIndex + 1);
        
        if (!line) continue;
        
        try {
            const request = JSON.parse(line);
            
            // Handle MCP 'initialize' Request
            if (request.method === "initialize") {
                sendMCPResponse(request.id, {
                    protocolVersion: "2024-11-25", // Standard MCP Protocol version
                    capabilities: {
                        tools: { listChanged: true },
                        resources: { subscribe: true },
                        prompts: { listChanged: true },
                        logging: {}
                     },
                    serverInfo: { name: SERVER_NAME, version: SERVER_VERSION }
                });
                continue;
            }
            
            // Handle MCP 'notifications/initialized'
            if (request.method === "notifications/initialized") {
                console.error("GAF-Sync Bridge: MCP Client Initialization complete.");
                continue;
            }

            // Handle MCP 'ping'
            if (request.method === "ping") {
                sendMCPResponse(request.id, {});
                continue;
            }

            // Handle MCP 'tools/list'
            if (request.method === "tools/list") {
                sendMCPResponse(request.id, {
                    tools: GAF_TOOLS
                });
                continue;
            }
            
            // --- NEW: RESOURCES & PROMPTS HANDLERS ---
            
            if (request.method === "resources/list") {
                sendMCPResponse(request.id, {
                    resources: [
                        {
                            uri: "godot://project_settings/autoloads",
                            name: "Project Autoloads",
                            description: "List of all active global singletons in the Godot project.",
                            mimeType: "application/json"
                        },
                        {
                            uri: "godot://input/actions",
                            name: "Input Map Actions",
                            description: "List of all mapped input actions (e.g., jump_player, ui_accept).",
                            mimeType: "application/json"
                        }
                    ]
                });
                continue;
            }
            
            if (request.method === "resources/read") {
                // In a production environment, this parses project.godot or makes a specific TCP call.
                // For now, we mock the retrieval of passive RAG data to complete the capability.
                const uri = request.params?.uri;
                let text = "Resource data for " + uri;
                if (uri === "godot://project_settings/autoloads") text = '{"autoloads": ["GlobalState", "AudioManager", "GAF_Sync"]}';
                if (uri === "godot://input/actions") text = '{"actions": ["ui_accept", "ui_cancel", "jump_player", "attack_melee"]}';
                
                sendMCPResponse(request.id, {
                    contents: [
                        {
                            uri: uri,
                            mimeType: "application/json",
                            text: text
                        }
                    ]
                });
                continue;
            }

            if (request.method === "prompts/list") {
                sendMCPResponse(request.id, {
                    prompts: [
                        {
                            name: "generate_ai_statemachine",
                            description: "Creates an AI State Machine with local studio conventions."
                        },
                        {
                            name: "analyze_ubershader_performance",
                            description: "Focuses the AI on 3D physics and shader performance evaluation."
                        }
                    ]
                });
                continue;
            }

            if (request.method === "prompts/get") {
                const promptName = request.params?.name;
                if (promptName === "generate_ai_statemachine") {
                    sendMCPResponse(request.id, {
                        description: "Generate an AI State Machine",
                        messages: [
                            {
                                role: "user",
                                content: {
                                    type: "text",
                                    text: "You are an expert Godot 4 developer. Generate a robust Hierarchical State Machine using the project's node conventions. Make sure to use GAF tools to create the nodes required."
                                }
                            }
                        ]
                    });
                } else if (promptName === "analyze_ubershader_performance") {
                    sendMCPResponse(request.id, {
                        description: "Analyze Ubershaders",
                        messages: [
                            {
                                role: "user",
                                content: {
                                    type: "text",
                                    text: "Review the geometries and shader complexity in the open scene. Output a markdown table evaluating performance implications in Godot 4.4."
                                }
                            }
                        ]
                    });
                } else {
                    sendMCPResponse(request.id, null, { code: -32602, message: "Prompt not found" });
                }
                continue;
            }
            
            // --- END NEW HANDLERS ---
            
            // Handle MCP 'tools/call'
            if (request.method === "tools/call") {
                if (!godotClient) {
                    sendMCPResponse(request.id, null, {
                        code: -32000, 
                        message: "Godot Editor not connected to GAF-Bridge"
                    });
                    continue;
                }

                const toolName = request.params?.name;
                const toolArgs = request.params?.arguments || {};
                
                // Map MCP Tool call to Godot
                const godotId = nextId++;
                const godotRequest = {
                    jsonrpc: "2.0",
                    id: godotId,
                    method: toolName,
                    params: toolArgs
                };

                const responsePromise = new Promise((resolve) => {
                    const timeout = setTimeout(() => {
                        pendingRequests.delete(godotId);
                        resolve({ error: { code: -32001, message: "Request to Godot timed out after 5 seconds." } });
                    }, 5000);
                    
                    pendingRequests.set(godotId, { 
                        resolve: (res) => {
                            clearTimeout(timeout);
                            resolve(res);
                        }
                    });
                });

                // Frame with \n for Godot stream splitting
                godotClient.write(JSON.stringify(godotRequest) + '\n');
                const result = await responsePromise;
                
                // Format response to MCP standard
                if (result.error) {
                    sendMCPResponse(request.id, {
                        content: [{ type: "text", text: JSON.stringify(result.error) }],
                        isError: true
                    });
                } else {
                    const isGodotError = result.result?.status === "error";
                    sendMCPResponse(request.id, {
                        content: [{ 
                            type: "text", 
                            text: typeof result.result === 'string' ? result.result : JSON.stringify(result.result, null, 2)
                        }],
                        isError: isGodotError
                    });
                }
                continue;
            }
            
        } catch (e) {
            // Log to stderr so it doesn't break the MCP stdout stream
            console.error("GAF-Bridge Error processing message:", e.message);
        }
    }
});
