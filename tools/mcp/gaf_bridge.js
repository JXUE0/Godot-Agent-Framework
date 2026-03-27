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
const SERVER_NAME = "gaf-sync-bridge";
const SERVER_VERSION = "1.4.0";

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

    socket.on('data', (data) => {
        try {
            const messages = data.toString().split('\n').filter(m => m.trim());
            for (const msgText of messages) {
                const message = JSON.parse(msgText);
                if (message.id && pendingRequests.has(message.id)) {
                    const { resolve } = pendingRequests.get(message.id);
                    pendingRequests.delete(message.id);
                    resolve(message);
                }
            }
        } catch (e) {
            console.error('GAF-Sync Bridge: Error parsing JSON data from Godot Editor:', e.message);
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
                    protocolVersion: "2024-11-05", // Standard MCP Protocol version
                    capabilities: { tools: {} },
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
