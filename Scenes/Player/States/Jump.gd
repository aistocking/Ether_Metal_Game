extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var walljumpdirection: int = 0

func enter(_msg := {}) -> void:
	player = owner
	player.velocity.y = player.JUMP_VELOCITY
	player.PlayerAnimations.play("Jump")
	player.SFXPlayer.set_stream(player.JumpSFX)
	player.SFXPlayer.play()
	player.CoyoteTimer.stop()
	if _msg.has("walljumpdirection"):
		walljumpdirection = _msg.walljumpdirection
		player.velocity.x = walljumpdirection * 150
	if Input.is_action_pressed("Dash"):
		player.setDashProperties()
	if player.IsDashing:
		player.speed = 450
	else:
		player.speed = 300

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
	if walljumpdirection != 0:
		if Input.is_action_pressed("Left"):
			player.changeFacingDirection(player.LEFT)
			if walljumpdirection == -1:
				walljumpdirection = 0
			player.velocity.x += -20
		if Input.is_action_pressed("Right"):
			player.changeFacingDirection(player.RIGHT)
			if walljumpdirection == 1:
				walljumpdirection = 0
			player.velocity.x += 20
	else:
		player.handle_horizontal()
	player.move_and_slide()
	
	if player.is_on_floor() && player.velocity.y == 0:
		state_machine.transition_to("Idle")	
