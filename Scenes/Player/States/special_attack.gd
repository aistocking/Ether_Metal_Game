extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum SPECIALS {HELMBRKR, UPPER, PLASMA, BARRAGE, STINGER, BLADE, BLINK, FLASH, PARRY, DISENGAGE, NONE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool
var IsInAir: bool
var CanCancel: bool

var direction: int

@onready var cancel_timer: Timer = $CancelTimer
@onready var _duration_timer: Timer = $DurationTimer

func enter(_msg := {}) -> void:
	player = owner
	CurrentSpecial = SPECIALS.NONE
	if _msg.has("direction"):
		direction = _msg.direction
	else:
		direction = player.facing_direction
	if _msg.has("IsOffensive"):
		IsOffensive = _msg.IsOffensive
	if !player.is_on_floor():
		IsInAir = true
	else:
		IsInAir = false
	designate_attack()
	if CurrentSpecial == SPECIALS.NONE:
		state_machine.transition_to("Idle")
	CanCancel = false

func exit():
	player.disable_parry_box()
	player.disable_collision(false)


func handle_input(event):
	if player.can_cancel:
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
			SPECIALS.DISENGAGE:
				#player.velocity = player.velocity.move_toward(Vector2.ZERO, 1200 * delta)
				player.velocity.y += gravity * delta
			SPECIALS.UPPER:
				pass
			SPECIALS.STINGER:
				pass
			SPECIALS.PARRY:
				player.velocity.y += gravity * delta
			SPECIALS.BLADE:
				player.velocity.y += gravity * delta
			SPECIALS.HELMBRKR:
				if player.is_on_floor():
					player.player_animations.play("Helm_Breaker_Ground")
					player.player_animations.seek(0.4, true)
					IsInAir = false
	#On ground behaviour
	else:
		match CurrentSpecial:
			SPECIALS.PLASMA:
				if !player.is_on_floor():
					state_machine.transition_to("Falling")
				player.create_dust()
			SPECIALS.DISENGAGE:
				player.velocity.y += gravity * delta
			SPECIALS.UPPER:
				pass
			SPECIALS.STINGER:
				player.create_dust()
			SPECIALS.PARRY:
				pass
			SPECIALS.BLADE:
				pass
	player.move_and_slide()

func reset_cancel() -> void:
	CanCancel = true

func designate_attack() -> void:
	if IsOffensive == true:
		if Input.is_action_pressed("Bottom Button"):
			_stinger()
		if Input.is_action_pressed("Right Button"):
			_helm_breaker()
		if Input.is_action_pressed("Top Button"):
			_upper()
		if Input.is_action_pressed("Left Button"):
			_plasma()
	else:
		if Input.is_action_pressed("Bottom Button"):
			_parry()
		if Input.is_action_pressed("Right Button"):
			pass
		if Input.is_action_pressed("Top Button"):
			pass
		if Input.is_action_pressed("Left Button"):
			_disengage()

func _plasma() -> void:
	if IsInAir == true:
		player.player_animations.play("Plasma_Shot_Air")
	else:
		player.player_animations.play("Plasma_Shot")
	CurrentSpecial = SPECIALS.PLASMA

func _stinger() -> void:
	player.player_animations.play("Stinger_Loop")
	CurrentSpecial = SPECIALS.STINGER

func _blade() -> void:
	player.player_animations.play("Parry")
	player.blade()
	CurrentSpecial = SPECIALS.BLADE

func _helm_breaker() -> void:
	if IsInAir:
		player.player_animations.play("Helm_Breaker_Air_Start")
		player.player_animations.queue("Helm_Breaker_Air_Loop")
	else:
		player.player_animations.play("Helm_Breaker_Ground")
	CurrentSpecial = SPECIALS.HELMBRKR

func _upper() -> void:
	player.player_animations.play("Upper")
	player.player_animations.queue("Upper_Loop")
	CurrentSpecial = SPECIALS.UPPER

func _disengage() -> void:
	player.velocity.x = player.facing_direction * -300
	player.velocity.y = -200
	var tweenX = get_tree().create_tween()
	tweenX.tween_property(player, "velocity:x", 0, .5).set_trans(Tween.TRANS_CUBIC)
	player.player_animations.play("Disengage")
	player.disengage()
	CurrentSpecial = SPECIALS.DISENGAGE

func _parry() -> void:
	player.player_animations.play("Parry_Wait")
	player.parry()
	CurrentSpecial = SPECIALS.PARRY

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
			"Stinger":
				state_machine.transition_to("Falling")
			"Stinger_Loop":
				state_machine.transition_to("Falling")
			"Disengage":
				state_machine.transition_to("Falling")
			"Parry":
				state_machine.transition_to("Falling")
			"Parry_Wait":
				state_machine.transition_to("Idle")
			"Flash":
				state_machine.transition_to("Falling")
			"Helm_Breaker_Ground":
				state_machine.transition_to("Idle")
			"Upper_Loop":
				state_machine.transition_to("Falling")
	#On ground behaviour
	else:
		match anim_name:
			"Plasma_Shot":
				state_machine.transition_to("Idle")
			"Stinger":
				state_machine.transition_to("Idle")
			"Stinger_Loop":
				state_machine.transition_to("Idle")
			"Disengage":
				state_machine.transition_to("Idle")
			"Parry":
				state_machine.transition_to("Idle")
			"Parry_Wait":
				state_machine.transition_to("Idle")
			"Flash":
				state_machine.transition_to("Idle")
			"Helm_Breaker_Ground":
				state_machine.transition_to("Idle")
			"Upper_Loop":
				state_machine.transition_to("Falling")
