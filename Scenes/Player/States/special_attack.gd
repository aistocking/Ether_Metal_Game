extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, STINGER, BLADE, BLINK, FLASH, PARRY, DISENGAGE, NONE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool
var IsInAir: bool

var direction: int

@onready var cancel_timer: Timer = $CancelTimer

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	CurrentSpecial = SPECIALS.NONE
	if _msg.has("direction"):
		direction = _msg.direction
	else:
		direction = player.facing_direction
	if _msg.has("IsOffensive"):
		IsOffensive = _msg.IsOffensive
	if !player.is_on_floor():
		IsInAir = true
	designate_attack()
	if CurrentSpecial == SPECIALS.NONE:
		state_machine.transition_to("Idle")
	

func handle_input(event):
	if cancel_timer.is_stopped():
		if event.is_action_pressed("Dash"):
			if Input.is_action_pressed("Left"):
				state_machine.transition_to("Dash", { "direction": player.LEFT })
			if Input.is_action_pressed("Right"):
				state_machine.transition_to("Dash", { "direction": player.RIGHT })
		if event.is_action_pressed("Jump"):
			state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	#Branch to either on ground behaviour or in air behaviour
	#In air behvaiour
	if IsInAir:
		match CurrentSpecial:
			SPECIALS.PLASMA:
				player.velocity.y += gravity * delta
				player.velocity.y = clamp(player.velocity.y, -25, 25)
				player.move_and_slide()
			SPECIALS.DISENGAGE:
				#player.velocity = player.velocity.move_toward(Vector2.ZERO, 1200 * delta)
				player.velocity.y += gravity * delta
				player.move_and_slide()
			SPECIALS.UPPER:
				player.move_and_slide()
			SPECIALS.STINGER:
				player.velocity.x = player.DASHING_SPEED * direction * 2
				player.move_and_slide()
			SPECIALS.PARRY:
				player.velocity.y += gravity * delta
				player.velocity.y = clamp(player.velocity.y, -25, 25)
				player.move_and_slide()
			SPECIALS.BLADE:
				player.velocity.y += gravity * delta
				player.velocity.y = clamp(player.velocity.y, -25, 25)
				player.move_and_slide()
	#On ground behaviour
	else:
		match CurrentSpecial:
			SPECIALS.PLASMA:
				if !player.is_on_floor():
					state_machine.transition_to("Falling")
				player.create_dust()
				player.move_and_slide()
			SPECIALS.DISENGAGE:
				player.velocity.y += gravity * delta
				player.move_and_slide()
			SPECIALS.UPPER:
				player.move_and_slide()
			SPECIALS.STINGER:
				player.velocity.x = player.DASHING_SPEED * direction
				player.create_dust()
				player.move_and_slide()
			SPECIALS.PARRY:
				pass
			SPECIALS.BLADE:
				pass
	

func designate_attack() -> void:
	if IsOffensive == true:
		if Input.is_action_pressed("Bottom Button"):
			_STINGER()
		if Input.is_action_pressed("Right Button"):
			_blade()
		if Input.is_action_pressed("Top Button"):
			_upper()
		if Input.is_action_pressed("Left Button"):
			_plasma()
	else:
		if Input.is_action_pressed("Bottom Button"):
			_disengage()
		if Input.is_action_pressed("Right Button"):
			pass
		if Input.is_action_pressed("Top Button"):
			pass
		if Input.is_action_pressed("Left Button"):
			_parry()

func _plasma() -> void:
	player.velocity.x = player.facing_direction * -200
	var tweenX = get_tree().create_tween()
	tweenX.tween_property(player, "velocity:x", 0, .4).set_trans(Tween.TRANS_CUBIC)
	if IsInAir == true:
		player.player_animations.play("Plasma_Shot_Air")
	else:
		player.player_animations.play("Plasma_Shot")
	player.plasma_shot()
	CurrentSpecial = SPECIALS.PLASMA
	cancel_timer.start(0.1)

func _STINGER() -> void:
	player.player_animations.play("STINGER")
	player.STINGER()
	CurrentSpecial = SPECIALS.STINGER

func _blade() -> void:
	player.player_animations.play("Parry")
	player.blade()
	CurrentSpecial = SPECIALS.BLADE
	cancel_timer.start(0.1)

func _barrage() -> void:
	player.player_animations.play("Plasma_Shot")
	player.barrage()
	CurrentSpecial = SPECIALS.BARRAGE
	cancel_timer.start(0.1)

func _upper() -> void:
	player.velocity.y = -500
	player.velocity.x = player.facing_direction * 300
	var tweenX = get_tree().create_tween()
	var tweenY = get_tree().create_tween()
	tweenX.tween_property(player, "velocity:x", 0, .3).set_ease(Tween.EASE_OUT)
	tweenY.tween_property(player, "velocity:y", 0, .5).set_ease(Tween.EASE_OUT)
	player.player_animations.play("Upper")
	player.upper(.5)
	CurrentSpecial = SPECIALS.UPPER
	cancel_timer.start(0.1)

func _disengage() -> void:
	player.velocity.x = player.facing_direction * -300
	player.velocity.y = -200
	var tweenX = get_tree().create_tween()
	tweenX.tween_property(player, "velocity:x", 0, .5).set_trans(Tween.TRANS_CUBIC)
	player.player_animations.play("Disengage")
	player.disengage()
	CurrentSpecial = SPECIALS.DISENGAGE
	cancel_timer.start(0.1)

func _parry() -> void:
	player.player_animations.play("Parry")
	player.parry()
	CurrentSpecial = SPECIALS.PARRY
	cancel_timer.start(0.1)

func _flash() -> void:
	player.player_animations.play("Flash")
	player.flash()
	CurrentSpecial = SPECIALS.FLASH

func _orbital_bit() -> void:
	player.orbital_bit()


func _on_player_anims_animation_finished(anim_name):
	#In air beviour
	if IsInAir:
		match anim_name:
			"Plasma_Shot_Air":
				state_machine.transition_to("Falling")
			"Upper":
				state_machine.transition_to("Falling")
			"STINGER":
				state_machine.transition_to("Falling")
			"Disengage":
				state_machine.transition_to("Falling")
			"Parry":
				state_machine.transition_to("Falling")
			"Flash":
				state_machine.transition_to("Falling")
	#On ground behaviour
	else:
		match anim_name:
			"Plasma_Shot":
				state_machine.transition_to("Idle")
			"Upper":
				state_machine.transition_to("Falling")
			"STINGER":
				state_machine.transition_to("Idle")
			"Disengage":
				state_machine.transition_to("Falling")
			"Parry":
				state_machine.transition_to("Idle")
			"Flash":
				state_machine.transition_to("Idle")
