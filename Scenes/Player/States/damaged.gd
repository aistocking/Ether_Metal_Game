extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.velocity.y = -150
	player.player_animations.play("Damaged_Start")
	player.player_animations.queue("Damaged_Loop")
	player.invincibility_timer.start(1.0)
	player.effect_audio_player.set_stream(player.DAMAGED_AUDIO)
	player.effect_audio_player.play()
	player.change_player_control(false)
	await get_tree().create_timer(0.35).timeout
	player.change_player_control(true)
	state_machine.transition_to("Idle")


func physics_update(delta: float) -> void:
	player.velocity.x += (player.facing_direction * -70) * delta
	player.velocity.y += gravity * delta
	
	player.move_and_slide()
