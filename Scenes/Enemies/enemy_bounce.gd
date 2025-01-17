extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D
var _impact_direction: int = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _timer: Timer = $DurationTimer

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_player.emit_signal("screen_shake", 1, 0.3)
	_enemy.velocity = Vector2.ZERO
	_enemy.sprite.frame = 0
	if _msg.has("impact_direction"):
		_impact_direction = _msg.impact_direction
	if _impact_direction == _enemy.LEFT:
		_enemy.velocity = Vector2(1, -1) * (_enemy.SHOVE_SPEED * 0.4)
	elif _impact_direction == _enemy.RIGHT:
		_enemy.velocity = Vector2(-1, -1) * (_enemy.SHOVE_SPEED * 0.4)
	else:
		_enemy.velocity = Vector2(0, -1) * (_enemy.SHOVE_SPEED * 0.4)
	var _tweenX = get_tree().create_tween()
	var _tweenY = get_tree().create_tween()
	_tweenX.tween_property(_enemy, "velocity:x", 0, .3).set_ease(Tween.EASE_OUT)
	_tweenY.tween_property(_enemy, "velocity:y", 0, .5).set_ease(Tween.EASE_OUT)
	_timer.start(1.5)

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	_enemy.rotation += 0.4
	_enemy.move_and_slide()

func exit() -> void:
	_enemy.rotation = 0


func _on_duration_timer_timeout():
	state_machine.transition_to("EnemyIdle")
