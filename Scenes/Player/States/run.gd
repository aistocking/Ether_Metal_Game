extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Run_Start")
	player.player_animations.queue("Run_Loop")
	player.reset_dash_properties()
	player.speed = player.DEFAULT_SPEED
	player.coyote_timer.stop()

func handle_input(event) -> void:
	if(player.player_input == false):
		return
	if event.is_action_pressed("Jump"):
		state_machine.transition_to("Jump")
	
	if event.is_action_pressed("Dash"):
		var direction = player.facing_direction
		state_machine.transition_to("Dash", { "direction": direction })

func physics_update(_delta: float) -> void:
	if !player.is_on_floor():
		player.coyote_timer.start(.08)
		state_machine.transition_to("Falling")
	
	
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if is_equal_approx(input_direction_x, 0.0) || player.player_input == false:
		state_machine.transition_to("Idle")
	
	player.handle_horizontal()
	player.move_and_slide()
