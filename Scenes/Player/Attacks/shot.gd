class_name Shot
extends Node2D

var _direction: Vector2
var _speed: float = 7
var _damage: int = 1
var _stun_damage: int = 4
var _power: float = 25

@onready var _hit_box: HitBox = $HitBox
@onready var _collision_point: Vector2 = $CollisionPoint.position

const _hit_fx: PackedScene = preload("res://Scenes/Effects/shot_effect.tscn")
const _hit_sparks: PackedScene = preload("res://Scenes/Effects/hit_fx.tscn")

func _ready():
	$Sprites.frame = randi_range(0,2)
	_hit_box.set_variables(_damage, _stun_damage, _direction, _power)
	if _direction.x < 0:
		flip()

func _physics_process(_delta):
	position += _direction * _speed

func set_direction(vec: Vector2) -> void:
	_direction = vec

func flip() -> void:
	$Sprites.flip_h = !$Sprites.flip_h
	_collision_point.x = _collision_point.x * -1
	

func _spawn_wall_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	hitFX.global_position = global_position
	get_parent().add_child(hitFX)

func _spawn_enemy_hit_sparks() -> void:
	var instance = _hit_sparks.instantiate()
	instance.position = global_position
	get_parent().add_child(instance)


func _on_hit_box_area_entered(hurtbox: HurtBox):
	_spawn_enemy_hit_sparks()
	queue_free()


func _on_physical_body_entered(body):
	_spawn_wall_hit_effect()
	queue_free()
