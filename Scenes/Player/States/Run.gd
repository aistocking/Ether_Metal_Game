extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("run")
	player.resetDashProperties()
	player.speed = 300

func handle_input(event) -> void:
	if event.is_action_pressed("Jump"):
		state_machine.transition_to("Jump")
	
	if event.is_action_pressed("Dash"):
		var direction = player.FacingDirection
		state_machine.transition_to("Dash", { "direction": direction })

func physics_update(_delta: float) -> void:

	if !player.is_on_floor():
		player.CayoteTimer.start(.15)
		state_machine.transition_to("Falling")
	
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	
	player.handle_horizontal()
	player.move_and_slide()
