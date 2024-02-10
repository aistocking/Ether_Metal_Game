extends State


var player: CharacterBody2D

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, BLINK, FLASH, PARRY, DISENGAGE}

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerSprite.play("idle")

func update(delta: float) -> void:
	pass
