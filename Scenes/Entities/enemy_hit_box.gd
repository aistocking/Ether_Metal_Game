extends Area2D

var _damage: int = 1

signal was_parried

func _ready() -> void:
	$Collision.disabled = true

func set_variables(damage: int) -> void:
	_damage = damage

func disable_collision(bul: bool) -> void:
	$Collision.set_deferred("disabled", bul)

func parried() -> void:
	disable_collision(true)
	emit_signal("was_parried")

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(_damage)


func _on_area_entered(area):
	parried()
