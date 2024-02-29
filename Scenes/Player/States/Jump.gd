extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity.y = player.JUMP_VELOCITY
	player.PlayerSprite.play("jump")
	player.SFXPlayer.set_stream(player.JumpSFX)
	player.SFXPlayer.play()
	player.CayoteTimer.stop()
	if Input.is_action_pressed("Dash"):
		player.setDashProperties()
	if player.IsDashing:
		player.speed = 450

func handle_input(event) -> void:
	if event.is_action_released("Jump"):
		state_machine.transition_to("Falling")
	
	if event.is_action_pressed("Dash") && !player.IsDashing:
		state_machine.transition_to("Dash")

func physics_update(delta: float) -> void:
	if player.IsDashing:
		player.ghostEffect()
	
	if player.velocity.y > 0:
		state_machine.transition_to("Falling")
		
	player.velocity.y += gravity * delta
	player.handle_horizontal()
	player.move_and_slide()
	
	if player.is_on_floor() && player.velocity.y == 0:
		state_machine.transition_to("Idle")	
