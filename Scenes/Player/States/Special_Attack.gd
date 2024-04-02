extends State


var player: CharacterBody2D

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, BLINK, FLASH, PARRY, DISENGAGE, NONE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	CurrentSpecial = SPECIALS.NONE
	if _msg.has("IsOffensive"):
		IsOffensive = _msg.IsOffensive
	if Input.is_action_pressed("Left Button") && IsOffensive:
		player.velocity.x = player.FacingDirection * -200
		player.PlayerAnimations.play("Plasma_Shot")
		player.plasmaShot()
		CurrentSpecial = SPECIALS.PLASMA
		player.ChargeLevel -= 1	
	if Input.is_action_pressed("Bottom Button") && !IsOffensive:
		player.velocity.x = player.FacingDirection * -200
		player.velocity.y = -150
		player.PlayerAnimations.play("Disengage")
		player.disengage()
		CurrentSpecial = SPECIALS.DISENGAGE
		player.ChargeLevel -= 1	
	if CurrentSpecial == SPECIALS.NONE:
		state_machine.transition_to("Idle")
	


func physics_update(delta: float) -> void:
	match CurrentSpecial:
		SPECIALS.PLASMA:
			if !player.is_on_floor():
				state_machine.transition_to("Falling")
			player.createDust()
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
			player.move_and_slide()
		SPECIALS.DISENGAGE:
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
			player.move_and_slide()
	


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Plasma_Shot":
			state_machine.transition_to("Idle")
		"Disengage":
			state_machine.transition_to("Falling")
