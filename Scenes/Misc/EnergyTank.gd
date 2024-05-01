extends AnimatedSprite2D


func _ready():
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("upgradeEnergy"):
		body.upgradeEnergy()
	queue_free()
