# Godot Networking — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Pattern
```gdscript
func host_game(port: int = 9999) -> void:
    var peer := ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
```

## Common pitfalls
- RPCs without server validation.
- Using unreliable RPCs for critical state.
