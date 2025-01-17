extends Control


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	animation_player.play("Intro")
	await animation_player.animation_finished
	_change_to_main_menu()


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		animation_player.stop()
		_change_to_main_menu()


func _change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/Misc/menus/main_menu.tscn")
