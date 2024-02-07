extends Area2D

var Direction
var Speed = 10
var Damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
<<<<<<< HEAD
	position += Direction * Speed
=======
	position += direction * speed
>>>>>>> b51dec78ace348a8b11d9cb8e36d3fb6c5df8edd

func getDirection(vec):
	Direction = vec

func flip(val):
	$Sprites.flip_h = val

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
<<<<<<< HEAD
	if(area.has_method("takeDamage")):
		area.takeDamage(Damage)
=======
>>>>>>> b51dec78ace348a8b11d9cb8e36d3fb6c5df8edd
	queue_free()
