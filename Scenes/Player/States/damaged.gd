extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer = $Timer

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.velocity.y = -150
	player.player_animations.play("Damaged_Start")
	player.player_animations.queue("Damaged_Loop")
	timer.start(0.35)
	player.invincibility_timer.start(1.0)
	player.effect_audio_player.set_stream(player.DAMAGED_AUDIO)
	player.effect_audio_player.play()
	player.change_player_control(false)

func physics_update(delta: float) -> void:
	player.velocity.x += (player.facing_direction * -70) * delta
	player.velocity.y += gravity * delta
	
	player.move_and_slide()

func _on_timer_timeout():
	timer.stop()
	player.change_player_control(true)
	if Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")
