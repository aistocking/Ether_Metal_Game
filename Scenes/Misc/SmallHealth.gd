extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_area_2d_body_entered(body):
	if body.has_method("restoreHealth"):
		body.restoreHealth(2)
	queue_free()
