extends State


var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, PUNCH, BLADE, BLINK, FLASH, PARRY, DISENGAGE, NONE}

var CurrentSpecial: SPECIALS

var IsOffensive: bool

var direction: int

var tweenX
var tweenY

@onready var cancel_timer: Timer = $CancelTimer

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
	

func handle_input(event):
	if(player.player_input == false or !cancel_timer.is_stopped()):
		return
	if event.is_action_pressed("Dash"):
		state_machine.transition_to("Dash")
	if event.is_action_pressed("Jump"):
		state_machine.transition_to("Jump")

func physics_update(delta: float) -> void:
	match CurrentSpecial:
		SPECIALS.PLASMA:
			if !player.is_on_floor():
				state_machine.transition_to("Falling")
			player.create_dust()
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
			player.move_and_slide()
		SPECIALS.DISENGAGE:
			player.velocity = player.velocity.move_toward(Vector2.ZERO, 1200 * delta)
			player.velocity.y += gravity * delta
			player.move_and_slide()
		SPECIALS.UPPER:
			if !tweenX.is_running():
				var tempVec = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
				player.velocity.x = tempVec.x
			if !tweenY.is_running():
				var tempVec = player.velocity.move_toward(Vector2.ZERO, 400 * delta)
				player.velocity.y = tempVec.y
			player.move_and_slide()
		SPECIALS.PUNCH:
			player.velocity.x = player.speed * direction
			player.create_dust()
			player.move_and_slide()
	

func designate_attack() -> void:
	if IsOffensive == true:
		if Input.is_action_pressed("Bottom Button"):
			pass
		if Input.is_action_pressed("Right Button"):
			pass
		if Input.is_action_pressed("Top Button"):
			pass
		if Input.is_action_pressed("Left Button"):
			pass
	else:
		if Input.is_action_pressed("Bottom Button"):
			pass
		if Input.is_action_pressed("Right Button"):
			pass
		if Input.is_action_pressed("Top Button"):
			pass
		if Input.is_action_pressed("Left Button"):
			pass

func _plasma() -> void:
	player.velocity.x = player.facing_direction * -200
	player.player_animations.play("Plasma_Shot")
	player.plasma_shot()
	CurrentSpecial = SPECIALS.PLASMA
	cancel_timer.start(0.1)

func _punch() -> void:
	player.player_animations.play("Punch")
	player.punch()
	CurrentSpecial = SPECIALS.PUNCH

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
	tweenX.tween_property(player, "velocity:x", player.facing_direction * 300, .2).set_trans(Tween.TRANS_CUBIC)
	tweenY.tween_property(player, "velocity:y", -200, .4).set_trans(Tween.TRANS_CUBIC)
	player.player_animations.play("Upper")
	player.upper(1)
	CurrentSpecial = SPECIALS.UPPER
	cancel_timer.start(0.1)

func _disengage() -> void:
	player.velocity.x = player.facing_direction * -300
	player.velocity.y = -200
	player.player_animations.play("Disengage")
	player.disengage()
	CurrentSpecial = SPECIALS.DISENGAGE

func _parry() -> void:
	player.player_animations.play("Parry")
	player.parry()
	CurrentSpecial = SPECIALS.PARRY

func _flash() -> void:
	player.player_animations.play("Flash")
	player.flash()
	CurrentSpecial = SPECIALS.FLASH

func _orbital_bit() -> void:
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
