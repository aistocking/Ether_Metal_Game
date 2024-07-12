class_name BladeBeam
extends Area2D

const speed: int = 4
var direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * speed

func set_direction(dir: int) -> void:
	if dir == -1:
		$BladeSprite.flip_h = true
	direction = dir


func _on_blade_timer_timeout():
	queue_free()
