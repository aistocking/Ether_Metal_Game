extends CanvasLayer

func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()

func _on_resume_pressed():
	toggle_pause()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func toggle_pause():
	visible = not visible
	get_tree().paused = visible
