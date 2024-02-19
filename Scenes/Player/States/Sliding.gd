extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("idle")
	player.resetDashProperties()

func update(_delta: float) -> void:
	pass
