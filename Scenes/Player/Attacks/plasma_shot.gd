class_name PlasmaShot
extends Node2D

var _direction: Vector2
var _speed: float = 1
var _damage: int = 8
var _stun_damage: int = 5
var _power: float = 300
var _hit_direction: Vector2

@onready var _hit_box: HitBox = $HitBox
@onready var _collision_point: Marker2D = $CollisionPoint

const _hit_fx: PackedScene = preload("res://Scenes/Effects/large_shot_effect.tscn")

func _ready():
	$Sprites.frame = randi_range(0,4)
	$GPUParticles2D.emitting = true
	_hit_direction.x = _direction.x
	_hit_box.set_variables(_damage, _stun_damage, _hit_direction, _power)
	create_tween().tween_property(self, "_speed", 10, 0.5)
	_set_flip()

func _physics_process(_delta):
	position += _direction * _speed

func set_direction(vec: Vector2):
	_direction = vec

func _set_flip() -> void:
	if _direction.x < 0:
		$Sprites.flip_h = !$Sprites.flip_h
		_collision_point.position.x *= -1
		$GPUParticles2D.process_material.direction.x *= -1
		$HitBox/HitCollision.transform.x *= -1
		$Physical/PhysicalCollision.transform.x *= -1

func _on_timer_timeout():
	_remove()

func _collission():
	_spawn_hit_effect()
	_remove()

func _spawn_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = $Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = _collision_point.global_position

func _remove() -> void:
	_speed = 0
	$Sprites.visible = false
	$GPUParticles2D.emitting = false
	$HitBox/HitCollision.disabled = true
	$Physical/PhysicalCollision.disabled = true
	await get_tree().create_timer(0.3).timeout
	queue_free()



func _on_physical_body_entered(body):
	_collission()
