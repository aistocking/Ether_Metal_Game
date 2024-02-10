extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.speed = 900
	
func physics_update(delta: float) -> void:
	player.handle_horizontal()
	player.move_and_slide()
