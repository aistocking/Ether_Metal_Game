extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D
var _direction: Vector2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _stun_instance: Node2D

signal stun_recover

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = _direction * _enemy.SHOVE_SPEED
	_stun_instance = _enemy._stun_fx.instantiate()
	_stun_instance.position = _enemy._stun_fx_spawn_marker.position
	_enemy.add_child(_stun_instance)
	_enemy.sprite.frame = 9

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	_enemy.move_and_slide()
	
func exit() -> void:
	emit_signal("stun_recover")
	_stun_instance.queue_free()


func _on_stun_timer_timeout():
	if _enemy.is_on_floor():
		state_machine.transition_to("EnemyIdle")
	else:
		state_machine.transition_to("EnemyRecover")
