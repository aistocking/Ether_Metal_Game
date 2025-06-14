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
	else:
		if Input.is_action_pressed("Offensive Trigger") or Input.is_action_pressed("Defensive Trigger"):
			if Input.is_action_pressed("Offensive Trigger") and Input.is_action_pressed("Defensive Trigger"):
				if event.is_action_pressed("Face Buttons") and player.charge_level >= 4:
					state_machine.transition_to("Special Attack", { "Ultimate": "beam" })
					return
					
			elif Input.is_action_pressed("Offensive Trigger"):
				if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
					state_machine.transition_to("Special Attack", { "IsOffensive": true })
					return
	
			elif Input.is_action_pressed("Defensive Trigger"):
				if event.is_action_pressed("Face Buttons") && player.charge_level != 0:
					state_machine.transition_to("Special Attack", { "IsOffensive": false })
					return
		
		if event.is_action_pressed("Jump"):
			state_machine.transition_to("Jump")
	
		if event.is_action_pressed("Shot"):
			if player._basic_shot() == true:
				player.player_animations.stop()
				player.player_animations.play("IdleShot")
	
		if event.is_action_pressed("Dash"):
			var direction = player.facing_direction
			state_machine.transition_to("Dash", { "direction": direction })
	
		
			

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		state_machine.transition_to("Falling")

	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	if player.player_input == false:
		return
	elif (left or right) and not (left and right):
		state_machine.transition_to("Run")
	player.move_and_slide()


func _on_player_anims_animation_finished(anim_name):
	if anim_name == "IdleShot":
		player.player_animations.play("Idle")
