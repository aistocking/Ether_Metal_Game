extends AnimatedSprite2D


func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body.has_method("upgradeHealth"):
		body.upgradeHealth()
	queue_free()
