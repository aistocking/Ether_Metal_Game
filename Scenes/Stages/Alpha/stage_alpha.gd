extends Node2D


func _ready() -> void:
	Global.change_music("res://Sound/Music/06_Opening Stage X.mp3")
	RenderingServer.set_default_clear_color(Color(0.5,0.5,0.5))


func _process(delta) -> void:
	pass
