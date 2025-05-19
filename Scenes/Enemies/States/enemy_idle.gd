extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO
	_enemy.anim_player.play("Idle")
	_enemy.player_detection_shape.set_deferred("disabled", false) 

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	if !_enemy.is_on_floor():
		_enemy.velocity.y += gravity * delta
		_enemy.move_and_slide()

func exit() -> void:
	pass
