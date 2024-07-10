extends State


var player: CharacterBody2D

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, PUNCH, BLINK, FLASH, PARRY, DISENGAGE, NONE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool

var direction: int

var tweenX
var tweenY

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	CurrentSpecial = SPECIALS.NONE
	tweenX = get_tree().create_tween()
	tweenY = get_tree().create_tween()
	if _msg.has("direction"):
		direction = _msg.direction
	else:
		direction = player.facing_direction
	if _msg.has("IsOffensive"):
		IsOffensive = _msg.IsOffensive
	designate_attack()
	if CurrentSpecial == SPECIALS.NONE:
		state_machine.transition_to("Idle")
	


func physics_update(delta: float) -> void:
	match CurrentSpecial:
		SPECIALS.PLASMA:
			if !player.is_on_floor():
				state_machine.transition_to("Falling")
			player.create_dust()
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
			player.move_and_slide()
		SPECIALS.DISENGAGE:
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
			player.move_and_slide()
		SPECIALS.UPPER:
			if !tweenX.is_running():
				var tempVec = player.velocity.move_toward(Vector2.ZERO, 1200 * delta)
				player.velocity.x = tempVec.x
			if !tweenY.is_running():
				var tempVec = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
				player.velocity.y = tempVec.y
			player.move_and_slide()
		SPECIALS.PUNCH:
			player.velocity.x = player.speed * direction
			player.move_and_slide()
	

func designate_attack() -> void:
	if IsOffensive == true:
		if Input.is_action_pressed("Bottom Button"):
			player.player_animations.play("Punch")
			player.punch()
			CurrentSpecial = SPECIALS.PUNCH
		if Input.is_action_pressed("Left Button"):
			player.velocity.x = player.facing_direction * -200
			player.player_animations.play("Plasma_Shot")
			player.plasma_shot()
			CurrentSpecial = SPECIALS.PLASMA
		if Input.is_action_pressed("Right Button"):
			player.player_animations.play("Plasma_Shot")
			player.barrage()
			CurrentSpecial = SPECIALS.BARRAGE
		if Input.is_action_pressed("Top Button"):
			tweenX.tween_property(player, "velocity:x", player.facing_direction * 300, .2).set_trans(Tween.TRANS_CUBIC)
			tweenY.tween_property(player, "velocity:y", -200, .4).set_trans(Tween.TRANS_CUBIC)
			player.player_animations.play("Upper")
			player.upper(1)
			CurrentSpecial = SPECIALS.UPPER
	else:
		if Input.is_action_pressed("Bottom Button"):
			player.velocity.x = player.facing_direction * -200
			player.velocity.y = -150
			player.player_animations.play("Disengage")
			player.disengage()
			CurrentSpecial = SPECIALS.DISENGAGE
		if Input.is_action_pressed("Left Button"):
			player.player_animations.play("Parry")
			player.parry()
			CurrentSpecial = SPECIALS.PARRY
		if Input.is_action_pressed("Top Button"):
			player.player_animations.play("Flash")
			player.flash()
			CurrentSpecial = SPECIALS.FLASH
		if Input.is_action_pressed("Right Button"):
			player.orbital_bit()


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Plasma_Shot":
			state_machine.transition_to("Idle")
		"Upper":
			state_machine.transition_to("Falling")
		"Punch":
			state_machine.transition_to("Idle")
		"Disengage":
			state_machine.transition_to("Falling")
		"Parry":
			state_machine.transition_to("Idle")
		"Flash":
			state_machine.transition_to("Idle")
