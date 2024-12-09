class_name HitBox
extends Area2D

@export var _damage: int
@export var _stun_damage: int
@export var _direction : Vector2

func set_damage_and_direction(damage: int, stun_damage: int, direction: Vector2) -> void:
	_damage = damage
	_stun_damage = stun_damage
	_direction = direction

func _on_area_entered(hurtbox: HurtBox) -> void:
	if(hurtbox.has_method("take_damage")):
		hurtbox.take_damage(_damage, _stun_damage, _direction)
