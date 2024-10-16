extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var prev_speed

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.player_animations.play("Falling")
	if player.is_dashing:
		player.speed = player.DASHING_SPEED

func handle_input(event):
	if(player.player_input == false):
		return
	if event.is_action_pressed("Dash") && player.spent_dash == false:
		state_machine.transition_to("Dash")
	
	if event.is_action_pressed("Jump") && !player.coyote_timer.is_stopped():
		state_machine.transition_to("Jump")
	
	if event.is_action_pressed("Shot"):
		player._basic_shot()

func physics_update(delta: float) -> void:
	if (player.is_on_floor()):
		state_machine.transition_to("Idle")
		
	if player.is_dashing:
		player.ghostEffect()
	
	if player.left_ray_cast.is_colliding() && Input.is_action_pressed("Left"):
		state_machine.transition_to("Sliding")
	
	if player.right_ray_cast.is_colliding() && Input.is_action_pressed("Right"):
		state_machine.transition_to("Sliding")
	
	player.velocity.y += gravity * delta
	player.velocity.y = clamp(player.velocity.y, -100, 800)
	player.handle_horizontal()
	player.move_and_slide()
	
func exit() -> void:
	player.speed = player.DEFAULT_SPEED
