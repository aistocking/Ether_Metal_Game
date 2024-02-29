class_name State
extends Node

var state_machine = null

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func on_animated_sprite_2d_animation_finished() -> void:
	pass

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass

func takeDamage() -> void:
	state_machine.transition_to("Damaged")

func die() -> void:
	state_machine.transition_to("Die")
