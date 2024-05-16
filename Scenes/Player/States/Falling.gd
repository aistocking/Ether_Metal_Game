extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.PlayerAnimations.play("Falling")
	if player.is_dashing:
		player.speed = 450
	else:
		player.speed = 300

func handle_input(event):
	if(player.player_input == false):
		return
	if event.is_action_pressed("Dash") && player.spent_dash == false:
		state_machine.transition_to("Dash")
	
	if event.is_action_pressed("Jump") && !player.CoyoteTimer.is_stopped():
		state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	if (player.is_on_floor()):
		state_machine.transition_to("Idle")
		
	if player.is_dashing:
		player.ghostEffect()
	
	if player.LeftRayCast.is_colliding() && Input.is_action_pressed("Left"):
		state_machine.transition_to("Sliding")
	
	if player.RightRayCast.is_colliding() && Input.is_action_pressed("Right"):
		state_machine.transition_to("Sliding")
	
	player.velocity.y += gravity * delta
	player.handle_horizontal()
	player.move_and_slide()
	
