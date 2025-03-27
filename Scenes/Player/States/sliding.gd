extends State


var player: CharacterBody2D

var direction: int

@onready var peel_timer = $PeelOffTimer

var gravity = (ProjectSettings.get_setting("physics/2d/default_gravity")) /8

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Wall_Slide")
	player.reset_dash_properties()
	if player.left_ray_cast.is_colliding():
		direction = player.RIGHT
	elif player.right_ray_cast.is_colliding():
		direction = player.LEFT
	player.change_facing_direction(direction)
	
func handle_input(event) -> void:
	if(player.player_input == false):
		return
	if event.is_action_pressed("Jump"):
		state_machine.transition_to("Jump", { "walljumpdirection": direction })
	
	#Check to see if the player is still "holding" onto the wall
	if event.is_action_released("Left") && player.left_ray_cast.is_colliding():
		peel_timer.start()
	
	if event.is_action_released("Right") && player.right_ray_cast.is_colliding():
		peel_timer.start()
	
	#These are technically unnecessary since the player would have to let go of the wall direction first
	if event.is_action_pressed("Left") && player.right_ray_cast.is_colliding():
		peel_timer.start()
	
	if event.is_action_pressed("Right") && player.left_ray_cast.is_colliding():
		peel_timer.start()
	
	if event.is_action_pressed("Shot"):
		player._basic_shot()


func physics_update(delta: float) -> void:
	if !player.left_ray_cast.is_colliding() && !player.right_ray_cast.is_colliding():
		state_machine.transition_to("Falling")
		
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	
	player.create_dust()

	player.velocity.y = gravity
	
	player.move_and_slide()


func _on_peel_off_timer_timeout():
	state_machine.transition_to("Falling")

func exit():
	peel_timer.stop()
