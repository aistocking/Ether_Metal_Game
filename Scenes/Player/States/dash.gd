extends State

var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = 0


var IsAirdash : bool

@onready var _dash_timer: Timer = $Timer
@onready var _shoot_timer: Timer = $ShotTimer

func enter(msg := {}) -> void:
	player = owner
	player.velocity = Vector2(0, 0)
	player.player_animations.play("Dash_Start")
	player.player_animations.queue("Dash_Loop")
	direction = 0
	_dash_timer.one_shot = true
	_dash_timer.start(0.4)
	player.effect_audio_player.set_stream(player.DASH_AUDIO)
	player.effect_audio_player.play()
	if(!player.is_on_floor()):
		player.set_dash_properties(true)
		IsAirdash = true
		player.velocity.y = 0
	else:
		IsAirdash = false
		player.set_dash_properties(false)
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
	
	if event.is_action_pressed("Shot"):
		player._basic_shot()
		if _shoot_timer.is_stopped():
			switchAnimation(false)
		_shoot_timer.start(0.4)


func exit() -> void:
	_dash_timer.stop()
	_shoot_timer.stop()
	
func physics_update(_delta: float) -> void:
	player.ghostEffect()

	player.velocity.x = player.DASHING_SPEED * direction

#This is to check if the Player dashes off a ledge and to discontinue that dash
	if (!IsAirdash && !player.is_on_floor()):
		player.coyote_timer.start(.07)
		state_machine.transition_to("Falling")
	
	player.move_and_slide()

func switchAnimation(back2dash: bool) -> void:
	var temp: float = player.player_animations.current_animation_position
	if back2dash:
		player.player_animations.play("Dash_Loop")
	else:
		player.player_animations.play("Dash_Shoot")
	player.player_animations.advance(temp)

# Make sure you stop the timer otherwise this can fire even outside of the state
func _on_timer_timeout():
	_dash_timer.stop()
	if IsAirdash:
		state_machine.transition_to("Falling")
	else:
		if(Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")


func _on_shot_timer_timeout():
	_shoot_timer.stop()
	switchAnimation(true)
