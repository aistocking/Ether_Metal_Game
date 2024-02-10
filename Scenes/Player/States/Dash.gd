extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0

@onready var timer = $Timer

func enter(msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.speed = 600
	direction = 0
	timer.one_shot = true
	timer.start(0.4)
	if (msg.has("direction")):
		direction = msg.direction

func exit() -> void:
	player.speed = 300
	timer.stop()
	
func physics_update(delta: float) -> void:
	if (Input.is_action_just_released("Dash")):
		if(Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
	if (Input.is_action_pressed("Left") && direction > 0):
		state_machine.transition_to("Run")
	if (Input.is_action_pressed("Right") && direction < 0):
		state_machine.transition_to("Run")
	player.velocity.x = player.speed * direction
	player.move_and_slide()

# Make sure you stop the timer otherwise this can fire even outside of the state
func _on_timer_timeout():
	if(Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")
