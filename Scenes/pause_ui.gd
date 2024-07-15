extends CanvasLayer


func _input(event) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/stage_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func change_special_buttons(is_defense:bool, button:String, special:String) -> void:
	if(is_defense == true):
		match button:
			"Bottom":
				$Specials/DefenseSpecials/Bottom.text = special
			"Right":
				$Specials/DefenseSpecials/Right.text = special
			"Top":
				$Specials/DefenseSpecials/Top.text = special
			"Left":
				$Specials/DefenseSpecials/Left.text = special
	else:
		match button:
			"Bottom":
				$Specials/OffensiveSpecials/Bottom.text = special
			"Right":
				$Specials/OffensiveSpecials/Right.text = special
			"Top":
				$Specials/OffensiveSpecials/Top.text = special
			"Left":
				$Specials/OffensiveSpecials/Left.text = special


func toggle_pause() -> void:
	Global.MusicPlayer.volume_db = Global.music_volume
	visible = not visible
	get_tree().paused = visible
	if visible:
		Global.MusicPlayer.volume_db -= 15 
		$VBoxContainer/HBoxContainer/Resume.grab_focus()


func _on_change_specials_pressed():
	$VBoxContainer.visible = false
	$Specials.visible = true
	$Specials/DefenseSpecials/Top.grab_focus()

func _on_back_button_pressed():
	$VBoxContainer.visible = true
	$Specials.visible = false
	$VBoxContainer/HBoxContainer/Resume.grab_focus()
