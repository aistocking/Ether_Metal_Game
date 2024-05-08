extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerAnimations.play("Idle")

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		player.velocity.y += gravity * delta
	player.move_and_slide()

func exitCutscene():
	state_machine.transition_to("Idle")
