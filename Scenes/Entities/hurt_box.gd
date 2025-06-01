class_name HurtBox
extends Area2D


signal damage_taken (health_damage: int, stun_damage: int, direction: Vector2, power: float)


func take_damage(health_damage: int, stun_damage: int, direction: Vector2, power: float) -> void:
	emit_signal("damage_taken", health_damage, stun_damage, direction, power)
