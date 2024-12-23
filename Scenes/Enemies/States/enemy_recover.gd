extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	_enemy.velocity.y += gravity * delta
	if _enemy.is_on_floor():
		state_machine.transition_to("EnemyIdle")
	_enemy.move_and_slide()
	
func exit() -> void:
	pass
