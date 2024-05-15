extends Control


func _ready() -> void:
	$"CenterContainer/Music Vloume".grab_focus()
	Global.change_music("res://Sound/Music/03_Title.mp3")
	$"CenterContainer/Music Vloume".value = Global.music_volume
	$"CenterContainer/SFX Volume".value = Global.get_effect_volume()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_music_vloume_value_changed(value: float) -> void:
	Global.music_volume = value
	Global.MusicPlayer.volume_db = Global.music_volume


func _on_sfx_volume_value_changed(value: float) -> void:
	Global.set_effect_volume(value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
