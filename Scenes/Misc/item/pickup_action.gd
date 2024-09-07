class_name PickupAction
extends Node


func on_pickup(node: Node2D) -> void:
	pass

func _warn(operation: String, node: Node2D) -> void:
	var item: String = get_path().get_concatenated_names()
	var pickupee: String = node.get_path().get_concatenated_names()
	push_warning("%s was picked up by %s which can't %s" % [item, pickupee, operation])
