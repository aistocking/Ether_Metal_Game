extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.velocity.x += (player.facing_direction * -70)
	player.velocity.y = -150
	player.player_animations.play("Damaged_Minor")
	player.invincibility_timer.start(1.0)
	player.effect_audio_player.set_stream(player.DAMAGED_AUDIO)
	player.effect_audio_player.play()
	player.change_player_control(false)


func physics_update(delta: float) -> void:
	player.velocity.y += gravity * delta
	
	player.move_and_slide()

func exit():
	player.change_player_control(true)

func _on_player_anims_animation_finished(anim_name):
	if anim_name == "Damaged_Minor":
		if player.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Falling")
