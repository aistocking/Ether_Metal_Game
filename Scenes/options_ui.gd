extends Control

@onready var _music: Slider = $"CenterContainer/MusicVolume"
@onready var _effect: Slider = $"CenterContainer/EffectVolume"

func _ready() -> void:
	_music.grab_focus()
	Global.change_music("res://Sound/Music/03_Title.mp3")
	_music.value = Global.music_volume
	_effect.value = Global.get_effect_volume()


func _on_music_volume_value_changed(value: float) -> void:
	Global.music_volume = value
	Global.MusicPlayer.volume_db = Global.music_volume


func _on_effect_volume_value_changed(value: float) -> void:
	Global.set_effect_volume(value)


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
