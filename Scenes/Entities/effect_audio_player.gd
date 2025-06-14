class_name EffectAudioPlayer
extends AudioStreamPlayer

func _ready():
	Global.effect_volume_changed.connect(_on_volume_changed)
	volume_db = Global.get_effect_volume()

func _on_volume_changed():
	volume_db = Global.get_effect_volume()

func play_sound(effect: AudioStream, start_time: float=0.0) -> void:
	set_stream(effect)
	play(start_time)
