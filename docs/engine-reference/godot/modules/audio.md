# Godot Audio — Quick Reference
Last verified: 2026-02-12 | Engine: Godot 4.6

## Cambios desde ~4.3
No hay cambios mayores de API en 4.4–4.6. Cambios son mas de workflow.

## Patrones actuales
### Reproducir audio
```gdscript
@onready var sfx_player: AudioStreamPlayer = %SFXPlayer

func play_sfx(stream: AudioStream) -> void:
    sfx_player.stream = stream
    sfx_player.play()
```

### Audio 3D
```gdscript
@onready var audio_3d: AudioStreamPlayer3D = %AudioPlayer3D

func _ready() -> void:
    audio_3d.max_distance = 50.0
```

### Buses
```gdscript
AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), -6.0)
```

## Errores comunes
- Crear AudioStreamPlayer en runtime sin pooling.
- No usar buses por categoria.
