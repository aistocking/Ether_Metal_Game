extends Node2D

var _music: AudioStream = preload("res://Sound/Music/06_Opening Stage X.mp3")

func _ready() -> void:
	Global.change_music(_music)
	RenderingServer.set_default_clear_color(Color(0.5,0.5,0.5))


func _process(delta) -> void:
	pass
