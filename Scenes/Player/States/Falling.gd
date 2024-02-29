extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	if player.IsDashing:
		player.speed = 450
	else:
		player.speed = 300

func handle_input(event):
	if event.is_action_pressed("Dash") && player.SpentDash == false:
		state_machine.transition_to("Dash")
	
	if event.is_action_pressed("Jump") && !player.CayoteTimer.is_stopped():
		state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	if player.IsDashing:
		player.ghostEffect()
	
	if player.LeftRayCast.is_colliding() && Input.is_action_pressed("Left"):
		state_machine.transition_to("Sliding")
	
	if player.RightRayCast.is_colliding() && Input.is_action_pressed("Right"):
		state_machine.transition_to("Sliding")
	
	player.velocity.y += gravity * delta
	player.handle_horizontal()
	player.move_and_slide()
	
	if (player.is_on_floor()):
		state_machine.transition_to("Idle")
