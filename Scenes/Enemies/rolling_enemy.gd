extends CharacterBody2D


const Speed = 50.0
var BounceVelocity = -100.0
var Direction : int = -1
var _health : int = 5
var _damage : int = 2
@onready var Sprite = $AnimatedSprite2D
const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if is_on_wall():
		Direction *= -1
	
	velocity.x = Direction * Speed
	velocity.y += gravity * delta

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var temp = velocity.bounce(collision_info.get_normal())
		velocity.y = temp.y
	
	move_and_slide()


func die():
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.position = global_position
	queue_free()

func takeDamage(damage):
	_health -= damage
	if _health <= 0:
		die()
	hitFlash()

func hitFlash():
	Sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	Sprite.material.set_shader_parameter("active", false)

func _on_hit_box_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(_damage)
