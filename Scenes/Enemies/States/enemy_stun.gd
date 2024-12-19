extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _stun_timer: Timer = $StunTimer

signal stun_recover

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO
	_stun_timer.start(5.0)

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	pass
	
func exit() -> void:
	emit_signal("stun_recover")


func _on_stun_timer_timeout():
	if _enemy.is_on_floor():
		state_machine.transition_to("EnemyIdle")
	else:
		state_machine.transition_to("EnemyRecover")
