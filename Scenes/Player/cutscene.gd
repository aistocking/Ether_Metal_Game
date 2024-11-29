extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.stop()
	player.change_player_control(false)
	player.process_mode = Node.PROCESS_MODE_ALWAYS

func physics_update(delta: float) -> void:
	player.move_and_slide()

func exit() -> void:
	player.change_player_control(true)
	player.process_mode = Node.PROCESS_MODE_INHERIT
