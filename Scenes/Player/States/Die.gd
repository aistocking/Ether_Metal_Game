extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Die")
	player.change_player_control(false)

func update(_delta: float) -> void:
	pass
