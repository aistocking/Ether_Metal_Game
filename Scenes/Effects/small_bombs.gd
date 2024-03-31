extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var damage: int = 5

var direction: int

var bounces: int = 0

func _ready():
	velocity.x = direction * 100


func _physics_process(delta):
	if is_on_floor():
		bounce()
	velocity.y += gravity * delta
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta)	
	move_and_slide()

func explode():
	$AnimatedSprite2D.animation = "explode"

func getDirection(dir):
	direction = dir
	if dir == 1:
		$AnimatedSprite2D.flip_h = true
	
func bounce():
	match bounces:
		0:
			velocity.y = -150
			bounces += 1
		1:
			velocity.y = -80
			bounces += 1
		2:
			velocity.y = -25
			bounces += 1
		3:
			bounces += 1

func _on_area_2d_area_entered(area):
	if(area.has_method("takeDamage")):
		area.takeDamage(damage)
		explode()

func _on_area_2d_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(damage)
		explode()

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_death_timer_timeout():
	explode()
