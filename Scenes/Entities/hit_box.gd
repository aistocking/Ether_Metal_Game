extends Area2D

@export var damage: int

func set_damage(value: int) -> void:
	damage = value

func _on_area_entered(area):
	if(area.has_method("take_damage")):
		area.takeDamage(damage)
