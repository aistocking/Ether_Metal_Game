extends CharacterBody2D

var _health: int = 5
var _damage: int = 1
const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")

var Player

@onready var _sprite = $Sprite
@onready var _hurt_box: HurtBox = $HurtBox

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
	_hurt_box.connect("damage_taken", _take_damage)

func _physics_process(delta):
	pass

func _take_damage(value: int):
	_health -= value
	if _health <= 0:
		die()
	hitFlash()

func hitFlash():
	_sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	_sprite.material.set_shader_parameter("active", false)

func die():
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.position = global_position
	queue_free()
	
