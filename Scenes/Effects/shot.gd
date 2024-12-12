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

func _ready():
	$Sprites.frame = randi_range(0,4)
	_hit_box.set_variables(_damage, _stun_damage, _direction, _power)

func _physics_process(_delta):
	position += _direction * _speed

func getDirection(vec: Vector2):
	_direction = vec

func flip(val):
	$Sprites.flip_h = val
	_collision_point.x = _collision_point.x * -1

func _on_timer_timeout():
	queue_free()

func _collission():
	_spawn_hit_effect()
	queue_free()


func _spawn_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = global_position



func _on_hit_box_area_entered(hurtbox: HurtBox):
	_collission()


func _on_physical_body_entered(body):
	_collission()
