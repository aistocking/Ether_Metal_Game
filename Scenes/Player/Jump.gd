extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, -400)
	player.PlayerSprite.play("jump")
	
func physics_update(delta: float) -> void:
	
	if (!Input.is_action_pressed("Jump") || player.velocity.y > 0):
		state_machine.transition_to("Falling")
		
	player.velocity.y += gravity * delta
	player.handle_horizontal()
	player.move_and_slide()
	
	if (player.is_on_floor()):
		state_machine.transition_to("Idle")	
