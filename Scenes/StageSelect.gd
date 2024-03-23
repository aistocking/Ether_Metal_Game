extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/AspectRatioContainer/GridContainer/Stage1.grab_focus()
	Global.changeMusic("res://Sound/Music/05_Stage Select.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_stage1_pressed():
	Global.changeMusic("res://Sound/Music/06_Opening Stage X.mp3")
	get_tree().change_scene_to_file("res://Scenes/test.tscn")


func _on_stage_2_pressed():
	Global.changeMusic("res://Sound/Music/06_Opening Stage X.mp3")
	get_tree().change_scene_to_file("res://Scenes/Stages/stage_alpha.tscn")
