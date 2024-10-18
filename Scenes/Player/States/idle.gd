extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Idle")
	player.reset_dash_properties()
	player.speed = player.DEFAULT_SPEED
	player.coyote_timer.stop()

func handle_input(event) -> void:
	if(player.player_input == false):
		return
	if Input.is_action_pressed("Offensive Trigger") || Input.is_action_pressed("Defensive Trigger"):
		if Input.is_action_pressed("Offensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
				state_machine.transition_to("Special Attack", { "IsOffensive": true })
	
		if Input.is_action_pressed("Defensive Trigger"):
			if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
				state_machine.transition_to("Special Attack", { "IsOffensive": false })
	else:
		if event.is_action_pressed("Jump"):
			state_machine.transition_to("Jump")
	
		if event.is_action_pressed("Dash"):
			var direction = player.facing_direction
			state_machine.transition_to("Dash", { "direction": direction })
	
		if event.is_action_pressed("Shot"):
			if player._basic_shot() == true:
				player.player_animations.play("IdleShot")
			

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		state_machine.transition_to("Falling")

	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	if player.player_input == false:
		return
	elif (left or right) and not (left and right):
		state_machine.transition_to("Run")


func _on_player_anims_animation_finished(anim_name):
	if anim_name == "IdleShot":
		player.player_animations.play("Idle")
