class_name PlasmaShot
extends Node2D

var _direction: Vector2
var _speed: float = 1
var _damage: int = 8
var _stun_damage: int = 5

@onready var _hit_box: HitBox = $HitBox
@onready var _collision_point: Marker2D = $CollisionPoint

const _hit_fx: PackedScene = preload("res://Scenes/Effects/large_shot_effect.tscn")

func _ready():
	$Sprites.frame = randi_range(0,4)
	_hit_box.set_damage_and_direction(_damage, _stun_damage, _direction)
	create_tween().tween_property(self, "_speed", 10, 0.5)

func _physics_process(_delta):
	position += _direction * _speed

func getDirection(vec: Vector2):
	_direction = vec

func flip(val):
	$Sprites.flip_h = val
	_collision_point.position.x = _collision_point.position.x * -1

func _on_timer_timeout():
	queue_free()

func _collission():
	_spawn_hit_effect()
	queue_free()

func _spawn_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = _collision_point.global_position



func _on_hit_box_area_entered(hurtbox: HurtBox):
	pass


func _on_physical_body_entered(body):
	_collission()
