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
	_enemy.sprite.frame = 9
	if _msg.has("direction"):
		_direction = _msg.direction
	_enemy.velocity = _direction * _enemy.SHOVE_SPEED
	_enemy._bouncy_collision.connect("wall_bounce", change_to_bounce)
	match _direction:
		Vector2(-1,0):
			_enemy._bouncy_collision.set_wall_bounce_collision("Left")
		Vector2(1,0):
			_enemy._bouncy_collision.set_wall_bounce_collision("Right")
		Vector2(0,-1):
			_enemy._bouncy_collision.set_wall_bounce_collision("Top")
		Vector2(0,1):
			_enemy._bouncy_collision.set_wall_bounce_collision("Bottom")



func change_to_bounce() -> void:
	state_machine.transition_to("EnemyBounce", {"impact_direction": _direction})

func physics_update(delta: float) -> void:
	if _direction.x == -1:
		_enemy.create_shove_trails(true)
	else:
		_enemy.create_shove_trails(false)
	_enemy.move_and_slide()
	
func exit() -> void:
	_enemy._bouncy_collision.set_wall_bounce_collision("Off")
