extends Area2D

var Direction
var Speed = 10
var Damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position += Direction * Speed

func getDirection(vec):
	Direction = vec

func flip(val):
	$Sprites.flip_h = val

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if(area.has_method("takeDamage")):
		area.takeDamage(Damage)
	queue_free()
