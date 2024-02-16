extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var timer = $Timer

func enter(_msg := {}) -> void:
	player = owner
	player.velocity.y = -50
	player.PlayerSprite.play("damaged")
	timer.start(0.5)

func physics_update(delta: float) -> void:
	player.velocity.x += (player.FacingDirection * -10) * delta
	player.velocity.y += gravity * delta

func _on_timer_timeout():
	if !Input.is_anything_pressed():
		state_machine.transition_to("Idle")
	elif Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
		state_machine.transition_to("Run")
