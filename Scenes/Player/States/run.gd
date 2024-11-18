extends State

var player: CharacterBody2D
@onready var shootTimer: Timer = $RunShootTimer

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
	if Input.is_action_pressed("Offensive Trigger") || Input.is_action_pressed("Defensive Trigger"):
		if Input.is_action_pressed("Offensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
				shootTimer.stop()
				state_machine.transition_to("Special Attack", { "IsOffensive": true })
	
		if Input.is_action_pressed("Defensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
				shootTimer.stop()
				state_machine.transition_to("Special Attack", { "IsOffensive": false })
	else:
		if event.is_action_pressed("Jump"):
			shootTimer.stop()
			state_machine.transition_to("Jump")
	
		if event.is_action_pressed("Dash"):
			var direction = player.facing_direction
			shootTimer.stop()
			state_machine.transition_to("Dash", { "direction": direction })
	
		if event.is_action_pressed("Shot"):
			player._basic_shot()
			if shootTimer.is_stopped():
				switchAnimation(false)
			shootTimer.start(0.4)
			

func physics_update(_delta: float) -> void:
	if !player.is_on_floor():
		player.coyote_timer.start(.08)
		shootTimer.stop()
		state_machine.transition_to("Falling")
	
	
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if is_equal_approx(input_direction_x, 0.0) || player.player_input == false:
		shootTimer.stop()
		state_machine.transition_to("Idle")
	
	player.handle_horizontal()
	player.move_and_slide()

func switchAnimation(back2run: bool):
	var temp = player.player_animations.current_animation_position
	if back2run:
		player.player_animations.play("Run_Loop")
	else:
		player.player_animations.play("Run_Shoot")
	player.player_animations.advance(temp)


func _on_run_shoot_timer_timeout():
	switchAnimation(true)
