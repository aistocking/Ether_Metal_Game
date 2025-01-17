class_name ShoveTrails
extends Node2D

func face_left() -> void:
	scale.x = scale.x * -1

func _on_animated_sprite_2d_animation_finished():
	queue_free()
