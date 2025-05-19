extends Area2D

var _damage: int = 1

signal was_parried

func _ready() -> void:
	$Collision.disabled = true

func set_variables(damage: int) -> void:
	_damage = damage

func set_collision(b: bool) -> void:
	$Collision.set_deferred("disabled", b)

func parried() -> void:
	set_collision(true)
	emit_signal("was_parried")

func _on_area_entered(area):
	if area.is_in_group("ParryBox"):
		parried()
	elif area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(_damage)
