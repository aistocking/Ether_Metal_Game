class_name MaxEnergyPickupAction
extends PickupAction


func on_pickup(node: Node2D) -> void:
	if node.has_method("upgrade_energy"):
		node.upgrade_energy()
	else:
		_warn("upgrade energy", node)
