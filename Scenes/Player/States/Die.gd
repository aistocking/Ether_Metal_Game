extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerAnimations.play("Die")
	player.changePlayerControl(false)

func update(_delta: float) -> void:
	pass
