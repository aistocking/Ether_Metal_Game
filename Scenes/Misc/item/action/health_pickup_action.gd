class_name HealthPickupAction
extends PickupAction


@export var health : int = 2


func on_pickup(node: Node2D) -> void:
	if node.has_method("restore_health"):
		node.restore_health(health)
	else:
		_warn("restore health", node)
