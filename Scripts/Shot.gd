extends StaticBody2D

var direction
var speed = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(direction * speed)

func getDirection(vec):
	direction = vec

func flip(val):
	$Sprites.flip_h = val

func _on_timer_timeout():
	queue_free()
