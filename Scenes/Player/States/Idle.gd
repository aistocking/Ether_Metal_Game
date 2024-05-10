extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerAnimations.play("Idle")
	player.resetDashProperties()
	player.speed = 300
	player.CoyoteTimer.stop()

func handle_input(event) -> void:
	if(player.PlayerInput == false):
		return
	if Input.is_action_pressed("Offensive Trigger") || Input.is_action_pressed("Defensive Trigger"):
		if Input.is_action_pressed("Offensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.ChargeLevel != 0:
				state_machine.transition_to("Special Attack", { "IsOffensive": true })
	
		if Input.is_action_pressed("Defensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.ChargeLevel != 0:
				state_machine.transition_to("Special Attack", { "IsOffensive": false })
	else:
		if event.is_action_pressed("Jump"):
			state_machine.transition_to("Jump")
	
		if event.is_action_pressed("Dash"):
			var direction = player.FacingDirection
			state_machine.transition_to("Dash", { "direction": direction })

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		state_machine.transition_to("Falling")

	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	if player.PlayerInput == false:
		return
	elif (left or right) and not (left and right):
		state_machine.transition_to("Run")
