class_name HealthProgressBar
extends ProgressBar


@export var _health_component: HealthComponent


func _ready() -> void:
	max_value = _health_component._max_health
	value = _health_component._health
	_health_component.connect("health_change", _update)

func _update(health: int, stun_health: int) -> void:
	value = _health_component._health
	pass
