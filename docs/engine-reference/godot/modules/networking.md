# Godot Networking — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
- 4.5/4.6: Sin rupturas mayores en API, pero revisar migraciones.

## Patrones actuales
```gdscript
func host_game(port: int = 9999) -> void:
    var peer := ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
```

## Errores comunes
- RPC sin validar en server.
- Usar `"unreliable"` para estado critico.
