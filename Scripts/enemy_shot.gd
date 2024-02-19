extends Area2D

var Direction : Vector2
var Speed : int = 5
var Damage : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Direction * Speed

func getDirection(vec : Vector2):
	Direction = vec

func _on_death_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(Damage)
		queue_free()
