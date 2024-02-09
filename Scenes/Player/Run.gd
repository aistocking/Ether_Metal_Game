extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("run")
	
func physics_update(delta: float) -> void:
	
	if (Input.is_action_just_pressed("Jump")):
		state_machine.transition_to("Jump")
	
	if (!player.is_on_floor()):
		state_machine.transition_to("Falling")
	
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	
	player.handle_horizontal()
	player.move_and_slide()
