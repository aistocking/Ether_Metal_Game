extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _stun_timer: Timer = $StunTimer
@onready var _stun_instance: Node2D

signal stun_recover

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO
	_stun_timer.start(5.0)
	_stun_instance = _enemy._stun_fx.instantiate()
	_stun_instance.position = _enemy._stun_fx_spawn_marker.position
	_enemy.add_child(_stun_instance)
	_enemy.sprite.frame = 9

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	if !_enemy.is_on_floor():
		_enemy.velocity.y += (gravity * delta) * 0.2
	else:
		_enemy.velocity.y = 0
	_enemy.velocity.x = move_toward(_enemy.velocity.x, 0, 1)
	_enemy.move_and_slide()
	
func exit() -> void:
	pass


func _on_stun_timer_timeout():
	emit_signal("stun_recover")
	_stun_instance.queue_free()
	if _enemy.is_on_floor():
		state_machine.transition_to("EnemyIdle")
	else:
		state_machine.transition_to("EnemyRecover")
