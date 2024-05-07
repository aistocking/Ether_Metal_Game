extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Start.grab_focus()
	Global.changeMusic("res://Sound/Music/03_Title.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/stage_select.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_UI.tscn")
