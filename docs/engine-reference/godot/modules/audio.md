# Godot Audio — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Patterns
```gdscript
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer

func play_sfx(stream: AudioStream) -> void:
    sfx_player.stream = stream
    sfx_player.play()
```

## 3D Audio
```gdscript
@onready var audio_3d: AudioStreamPlayer3D = %AudioPlayer3D

func _ready() -> void:
    audio_3d.max_distance = 50.0
```

## Buses
```gdscript
AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), -6.0)
```

## Common pitfalls
- Creating AudioStreamPlayer in runtime without pooling.
- Not using buses by category.
