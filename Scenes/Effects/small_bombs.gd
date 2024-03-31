extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var damage: int = 5

var direction: int

func _ready():
	velocity.x = direction * 100


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta)
	move_and_slide()

func explode():
	$AnimatedSprite2D.animation = "explode"

func getDirection(dir):
	direction = dir

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
