extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = 0

var prev_speed: int

var IsAirdash : bool

@onready var timer: Timer = $Timer

func enter(msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	prev_speed = player.speed
	player.speed = player.speed * 2
	player.player_animations.play("Dash_Start")
	player.player_animations.queue("Dash_Loop")
	player.set_dash_properties()
	direction = 0
	timer.one_shot = true
	timer.start(0.4)
	player.effect_audio_player.set_stream(player.DASH_AUDIO)
	player.effect_audio_player.play()
	if(!player.is_on_floor()):
		IsAirdash = true
		player.spent_dash = true
		player.velocity.y = 0
	else:
		IsAirdash = false
	if (msg.has("direction")):
		direction = msg.direction
	else:
		direction = player.facing_direction

func handle_input(event):
	if(player.player_input == false):
		return
	if event.is_action_pressed("Left") && direction > 0:
		state_machine.transition_to("Run")
	if event.is_action_pressed("Right") && direction < 0:
		state_machine.transition_to("Run")
	if event.is_action_released("Dash"):
		if IsAirdash:
			state_machine.transition_to("Falling")
		else:
			if event.is_action_pressed("Left") || event.is_action_pressed("Right"):
				state_machine.transition_to("Run")
			else:
				state_machine.transition_to("Idle")
	if event.is_action_pressed("Jump") && !IsAirdash:
		state_machine.transition_to("Jump")
	


func exit() -> void:
	player.speed = prev_speed
	timer.stop()
	
func physics_update(_delta: float) -> void:
	player.ghostEffect()

	player.velocity.x = player.speed * direction

#This is to check if the Player dashes off a ledge and to discontinue that dash
	if (!IsAirdash && !player.is_on_floor()):
		player.coyote_timer.start(.07)
		state_machine.transition_to("Falling")
	
	player.move_and_slide()

# Make sure you stop the timer otherwise this can fire even outside of the state
func _on_timer_timeout():
	timer.stop()
	if IsAirdash:
		state_machine.transition_to("Falling")
	else:
		if(Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
