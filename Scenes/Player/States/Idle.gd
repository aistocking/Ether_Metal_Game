extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("idle")
	player.resetDashProperties()
	player.speed = 300
	player.CayoteTimer.stop()

func handle_input(event) -> void:
	if event.is_action_pressed("Jump"):
		state_machine.transition_to("Jump")
	
	if event.is_action_pressed("Dash"):
		var direction = player.FacingDirection
		state_machine.transition_to("Dash", { "direction": direction })

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		state_machine.transition_to("Falling")
	
	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	
	if (left or right) and not (left and right):
		state_machine.transition_to("Run")
