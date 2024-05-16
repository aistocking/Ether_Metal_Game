extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/AspectRatioContainer/GridContainer/Stage1.grab_focus()
	Global.change_music("res://Sound/Music/05_Stage Select.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_stage1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/Alpha/stage_alpha.tscn")


func _on_stage_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/Beta/stage_beta.tscn")
