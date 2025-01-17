class_name HitBox
extends Area2D

@export var _damage: int
@export var _stun_damage: int
@export var _direction: Vector2
@export var _power: float

signal hit

func set_variables(damage: int, stun_damage: int, direction: Vector2, power: float) -> void:
	_damage = damage
	_stun_damage = stun_damage
	_direction = direction
	_power = power

func _on_area_entered(hurtbox: HurtBox) -> void:
	emit_signal("hit")
	if(hurtbox.has_method("take_damage")):
		hurtbox.take_damage(_damage, _stun_damage, _direction, _power)
