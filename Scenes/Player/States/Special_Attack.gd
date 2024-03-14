extends State


var player: CharacterBody2D

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, BLINK, FLASH, PARRY, DISENGAGE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	if _msg.has("IsOffensive"):
		IsOffensive = _msg.IsOffensive
	if Input.is_action_pressed("Left Button"):
		CurrentSpecial = SPECIALS.PLASMA
		player.velocity.x = player.FacingDirection * -200
		player.plasmaShot()
	player.PlayerSprite.play("charge_shot")


func physics_update(delta: float) -> void:
	player.createDust()
	player.velocity.x += player.FacingDirection * 7
	player.move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	state_machine.transition_to("Idle")
