#!/usr/bin/env node
const net = require('net');

/**
 * GAF-SYNC BRIDGE V1.3.1 (PURE TCP)
 * Protocol: TCP / JSON-RPC 2.0
 * Port: 1342
 * Security: Localhost-Only (127.0.0.1)
 * Dependencies: None (Pure Node.js)
 */

const PORT = 1342;
const HOST = '127.0.0.1';
let godotClient = null;
let nextId = 1;
const pendingRequests = new Map();

const server = net.createServer((socket) => {
    // Security: Filter non-localhost connections
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
    console.error('Status: Localhost-Only Security Active (Professional Standard)');
});

/**
 * MCP HANDLER (STDIO Interface)
 */
process.stdin.on('data', async (data) => {
    const lines = data.toString().split('\n');
    for (const line of lines) {
        if (!line.trim()) continue;
        try {
            const request = JSON.parse(line);
            if (request.method && godotClient) {
                const godotId = nextId++;
                const godotRequest = {
                    jsonrpc: "2.0",
                    id: godotId,
                    method: request.method,
                    params: request.params || {}
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

                // Frame with \n for Godot-side stream splitting
                godotClient.write(JSON.stringify(godotRequest) + '\n');

                const result = await responsePromise;
                process.stdout.write(JSON.stringify({
                    jsonrpc: "2.0",
                    id: request.id,
                    result: result.result || result.error
                }) + '\n');
            } else {
                process.stdout.write(JSON.stringify({
                    jsonrpc: "2.0",
                    id: request.id,
                    error: { code: -32000, message: "Godot Editor not connected to GAF-Bridge" }
                }) + '\n');
            }
        } catch (e) {
            // Handle parsing errors silently for production stability
        }
    }
});
