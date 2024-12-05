class_name HurtBox
extends Area2D

signal damage_taken (damage: int)

func take_damage(value: int) -> void:
	emit_signal("damage_taken", value)
	
