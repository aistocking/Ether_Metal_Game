extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D
var _impact_direction: Vector2

var _tweenX: Tween
var _tweenY: Tween

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _timer: Timer = $DurationTimer

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy._camera.apply_shake(1.5, 0.1)
	_enemy._effect_audio_player.play_sound(_enemy._wall_hit_sfx)
	_enemy.velocity = Vector2.ZERO
	_enemy.sprite.frame = 0
	if _msg.has("impact_direction"):
		_impact_direction = _msg.impact_direction
	match _impact_direction:
		Vector2(-1,0):
			_enemy.velocity = Vector2(1, -1) * (_enemy.SHOVE_SPEED * 0.4)
		Vector2(1,0):
			_enemy.velocity = Vector2(-1, -1) * (_enemy.SHOVE_SPEED * 0.4)
		Vector2(0,-1):
			_enemy.velocity = Vector2(0, 1) * (_enemy.SHOVE_SPEED * 0.4)
		Vector2(0,1):
			_enemy.velocity = Vector2(0,-1) * (_enemy.SHOVE_SPEED * 0.4)
	_tweenX = get_tree().create_tween()
	_tweenY = get_tree().create_tween()
	_tweenX.tween_property(_enemy, "velocity:x", 0, .3).set_ease(Tween.EASE_OUT)
	_tweenY.tween_property(_enemy, "velocity:y", 0, 1).set_ease(Tween.EASE_OUT)
	_tweenY.chain().tween_property(_enemy, "velocity:y", gravity, 5).set_ease(Tween.EASE_OUT)
	_timer.start(2)

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	_enemy.sprite.rotation += 0.4
	_enemy.move_and_slide()

func exit() -> void:
	_tweenX.kill()
	_tweenX.kill()
	_enemy.sprite.rotation = 0
	_enemy._restore_stun()


func _on_duration_timer_timeout():
	state_machine.transition_to("EnemyIdle")
