extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer = $Timer

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.velocity.y = -150
	player.PlayerSprite.play("damaged")
	timer.start(0.35)
	player.InvulnerabilityTimer.start(1.0)

func physics_update(delta: float) -> void:
	player.velocity.x += (player.FacingDirection * -70) * delta
	player.velocity.y += gravity * delta
	
	player.move_and_slide()

func _on_timer_timeout():
	if Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
		state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Idle")
