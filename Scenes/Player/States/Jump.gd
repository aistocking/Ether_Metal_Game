extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity.y = player.JUMP_VELOCITY
	player.PlayerSprite.play("jump")
	
func physics_update(delta: float) -> void:
	if(player.IsDashing):
		player.ghostEffect()
	
	if (Input.is_action_just_released("Jump") || player.velocity.y > 0):
		state_machine.transition_to("Falling")
	
	if(Input.is_action_just_pressed("Dash")):
		state_machine.transition_to("Dash")
		
	player.velocity.y += gravity * delta
	player.handle_horizontal()
	player.move_and_slide()
	
	if (player.is_on_floor() && player.velocity.y == 0):
		state_machine.transition_to("Idle")	
