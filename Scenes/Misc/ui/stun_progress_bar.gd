class_name StunProgressBar
extends ProgressBar


@export var _health_component: HealthComponent


func _ready() -> void:
	max_value = _health_component._max_stun_health
	value = _health_component._stun_health
	_health_component.connect("health_change", _update)


func _update(_health: int, stun_health: int) -> void:
	value = stun_health
