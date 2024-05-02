extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO

func exitCutscene():
	state_machine.transition_to("Idle")
