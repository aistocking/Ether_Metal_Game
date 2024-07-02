extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Perun.grab_focus()
	Global.change_music("res://Sound/Music/05_Stage Select.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_perun_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/Alpha/stage_alpha.tscn")


func _on_volos_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/Beta/stage_beta.tscn")




func _on_perun_focus_entered() -> void:
	$Cursor.position = Vector2(64, 45)
	$EffectAudioPlayer.play()


func _on_volos_focus_entered() -> void:
	$Cursor.position = Vector2(128, 45)
	$EffectAudioPlayer.play()


func _on_player_options_focus_entered() -> void:
	$Cursor.position = Vector2(200, 45)
	$EffectAudioPlayer.play()


func _on_yaryla_focus_entered() -> void:
	$Cursor.position = Vector2(272, 45)
	$EffectAudioPlayer.play()


func _on_marena_focus_entered() -> void:
	$Cursor.position = Vector2(336, 45)
	$EffectAudioPlayer.play()


func _on_mokosh_focus_entered() -> void:
	$Cursor.position = Vector2(64, 174)
	$EffectAudioPlayer.play()


func _on_svetovit_focus_entered() -> void:
	$Cursor.position = Vector2(128, 174)
	$EffectAudioPlayer.play()


func _on_intro_stage_focus_entered() -> void:
	$Cursor.position = Vector2(200, 174)
	$EffectAudioPlayer.play()


func _on_svarog_focus_entered() -> void:
	$Cursor.position = Vector2(272, 174)
	$EffectAudioPlayer.play()


func _on_belobog_focus_entered() -> void:
	$Cursor.position = Vector2(336, 174)
	$EffectAudioPlayer.play()
