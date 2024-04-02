extends AnimatedSprite2D

var damage = 15

var time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathTimer.start(time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode():
	queue_free()

func _on_hit_box_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(damage)


func _on_death_timer_timeout():
	explode()


func _on_hit_box_area_entered(area):
	if(area.has_method("takeDamage")):
		area.takeDamage(damage)
