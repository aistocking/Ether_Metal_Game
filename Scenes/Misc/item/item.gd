class_name Item
extends Area2D

func _ready() -> void:
	collision_layer = 32
	connect("body_entered", _on_body_entered)


func _on_body_entered(node: Node2D) -> void:
	var children = get_children()
	for c in children:
		if c is PickupAction:
			c.on_pickup(node)
	queue_free()
