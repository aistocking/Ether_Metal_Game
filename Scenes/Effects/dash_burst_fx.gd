extends AnimatedSprite2D

func face_left() -> void:
	scale.x = scale.x *-1

func face_up() -> void:
	rotation_degrees = -90.0

func _on_animation_finished():
	queue_free()
