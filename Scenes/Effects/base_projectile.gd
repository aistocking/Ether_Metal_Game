extends Node2D

var _spawn_location: Marker2D
var _direction: Vector2 = Vector2(1, 0)
var _speed: float = 1
var _start_speed: float = 0
var _tween_time: float = 1
var _damage: int = 1
var _stun_damage: int = 1
var _power: float = 10
var _hit_direction: Vector2 =Vector2(1, 0)

@onready var _hit_box: HitBox = $HitBox
@onready var _collision_point: Marker2D = $CollisionPoint
@onready var _life_timer: Timer = $LifeTimer

var _player: PlayerCharacter

var _random_sprite_start: bool = false
var _homing: bool = false
var _tween_speed: bool = false
var _peircing: bool = false

var _hit_fx_node_path: String

var _hit_fx: PackedScene

func _ready():
	position = _spawn_location.global_position
	_hit_box.set_variables(_damage, _stun_damage, _hit_direction, _power)
	_hit_fx = load(_hit_fx_node_path)
	
	if _random_sprite_start == true:
		$Sprites.frame = randi_range(0,4)
	if _tween_speed == true:
		create_tween().tween_property(self, "_speed", _start_speed, _tween_time)

func _physics_process(delta):
	position += _direction * _speed * delta

func _set_flip() -> void:
	if _direction.x < 0:
		$Sprites.flip_h = !$Sprites.flip_h
		_collision_point.position.x *= -1

func _collission():
	_spawn_hit_effect()
	queue_free()

func _spawn_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = _collision_point.global_position


func _on_hit_box_area_entered(hurtbox: HurtBox):
	if !_peircing:
		_collission()


func _on_physical_collision_body_entered(body):
	_collission()
