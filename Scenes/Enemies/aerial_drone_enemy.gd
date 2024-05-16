extends CharacterBody2D

var _health: int = 5
var _damage: int = 1
const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")

var Player

@onready var Sprite = $AnimatedSprite2D

func _ready():
	Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	position = position.move_toward(Player.position, 50 * delta)
	move_and_slide()

func takeDamage(damage):
	_health -= damage
	if _health <= 0:
		die()
	hitFlash()

func hitFlash():
	Sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	Sprite.material.set_shader_parameter("active", false)

func die():
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.position = global_position
	queue_free()
	

func _on_area_2d_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(_damage)
