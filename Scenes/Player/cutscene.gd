extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.pause()
	player.change_player_control(false)
	player.disable_collision(true)
	player.process_mode = Node.PROCESS_MODE_ALWAYS

func physics_update(delta: float) -> void:
	player.move_and_slide()

func exit() -> void:
	player.disable_collision(false)
	player.change_player_control(true)
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
