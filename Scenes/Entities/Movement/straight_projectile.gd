class_name StraightProjectile
extends Node


@export var direction := Vector2.RIGHT
@export var speed := 1.0
@export var final_speed := 10
@export var duration := 0.5
@onready var parent = get_parent()

func _ready() -> void:
	create_tween().tween_property(self, "speed", final_speed, duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parent.position += direction * speed
