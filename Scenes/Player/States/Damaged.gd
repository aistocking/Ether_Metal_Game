extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer = $Timer

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.velocity.y = -150
	player.PlayerAnimations.play("Damaged_Start")
	player.PlayerAnimations.queue("Damaged_Loop")
	timer.start(0.35)
	player.InvulnerabilityTimer.start(1.0)
	player.SFXPlayer.set_stream(player.DamagedSFX)
	player.SFXPlayer.play()
	player.changePlayerControl(false)

func physics_update(delta: float) -> void:
	player.velocity.x += (player.facing_direction * -70) * delta
	player.velocity.y += gravity * delta
	
	player.move_and_slide()

func _on_timer_timeout():
	timer.stop()
	player.changePlayerControl(true)
	if Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")
