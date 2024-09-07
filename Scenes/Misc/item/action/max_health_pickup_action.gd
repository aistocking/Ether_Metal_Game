class_name MaxHealthPickupAction
extends PickupAction


func on_pickup(node: Node2D) -> void:
	if node.has_method("upgrade_health"):
		node.upgrade_health()
	else:
		_warn("upgrade health", node)
