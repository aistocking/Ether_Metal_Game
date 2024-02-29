extends State


var player: CharacterBody2D

var gravity = (ProjectSettings.get_setting("physics/2d/default_gravity")) /3

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("idle")
	player.resetDashProperties()

func handle_input(event) -> void:
	if event.is_action_pressed("Jump"):
		player.velocity.x = player.FacingDirection * -50
		state_machine.transition_to("Jump")
	
	if event.is_action_released("Left") && player.LeftRayCast.is_colliding():
		state_machine.transition_to("Falling")
	
	if event.is_action_released("Right") && player.RightRayCast.is_colliding():
		state_machine.transition_to("Falling")
	
	if event.is_action_released("Left") && player.RightRayCast.is_colliding():
		state_machine.transition_to("Falling")
	
	if event.is_action_released("Right") && player.LeftRayCast.is_colliding():
		state_machine.transition_to("Falling")


func physics_update(delta: float) -> void:
	if !player.LeftRayCast.is_colliding() && !player.RightRayCast.is_colliding():
		state_machine.transition_to("Falling")
		
	if player.is_on_floor():
		state_machine.transition_to("Idle")

	player.velocity.y += gravity * delta
	
	player.move_and_slide()
