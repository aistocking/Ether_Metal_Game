extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0

var IsAirdash : bool

@onready var timer = $Timer

func enter(msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.speed = 600
	player.PlayerSprite.play("dash")
	player.setDashProperties()
	direction = 0
	timer.one_shot = true
	timer.start(0.4)
	if(!player.is_on_floor()):
		IsAirdash = true
		player.SpentDash = true
		player.velocity.y = 0
	else:
		IsAirdash = false
	if (msg.has("direction")):
		direction = msg.direction
	else:
		direction = player.FacingDirection

func handle_input(event):
	if event.is_action_pressed("Left") && direction > 0:
		state_machine.transition_to("Run")
	if event.is_action_pressed("Right") && direction < 0:
		state_machine.transition_to("Run")
	if (event.is_action_released("Dash")):
		if IsAirdash:
			state_machine.transition_to("Falling")
		else:
			if(event.is_action_pressed("Left") || event.is_action_pressed("Right")):
				state_machine.transition_to("Run")
			else:
				state_machine.transition_to("Idle")
	if (event.is_action_pressed("Jump") && !IsAirdash):
		state_machine.transition_to("Jump")


func exit() -> void:
	player.speed = 300
	timer.stop()
	
func physics_update(delta: float) -> void:
	player.ghostEffect()

	player.velocity.x = player.speed * direction

#This is to check if the Player dashes off a ledge and to discontinue that dash
	if (!IsAirdash && !player.is_on_floor()):
		state_machine.transition_to("Falling")
	
	player.move_and_slide()

# Make sure you stop the timer otherwise this can fire even outside of the state
func _on_timer_timeout():
	if IsAirdash:
		state_machine.transition_to("Falling")
	else:
		if(Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
