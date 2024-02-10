extends State

var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("idle")

func update(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		state_machine.transition_to("Run")
