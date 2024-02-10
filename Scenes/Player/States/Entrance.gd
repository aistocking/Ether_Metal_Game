extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("entrance")

func update(delta: float) -> void:
	pass

func on_animated_sprite_2d_animation_finished():
	state_machine.transition_to("Idle")
