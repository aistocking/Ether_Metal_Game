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
	_enemy._effect_audio_player.play_sound(_enemy._big_hit_sfx)
	_enemy.sprite.frame = 9
	if _msg.has("direction"):
		_direction = _msg.direction
	_enemy.velocity = _direction * _enemy.SHOVE_SPEED
	_enemy.left_ray_cast.enabled = true
	_enemy.right_ray_cast.enabled = true


func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	if _enemy.left_ray_cast.is_colliding():
		state_machine.transition_to("EnemyBounce", {"impact_direction": -1})
	if _enemy.right_ray_cast.is_colliding():
		state_machine.transition_to("EnemyBounce", {"impact_direction": 1})
	if _direction.x == -1:
		_enemy.create_shove_trails(true)
	else:
		_enemy.create_shove_trails(false)
	_enemy.move_and_slide()
	
func exit() -> void:
	_enemy.left_ray_cast.enabled = false
	_enemy.right_ray_cast.enabled = false
