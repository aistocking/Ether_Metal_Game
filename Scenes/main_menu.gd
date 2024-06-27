extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Start.grab_focus()
	Global.change_music("res://Sound/Music/03_Title.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/stage_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_ui.tscn")


func _on_start_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 155)
	$EffectAudioPlayer.play()


func _on_options_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 174)
	$EffectAudioPlayer.play()


func _on_quit_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 193)
	$EffectAudioPlayer.play()
