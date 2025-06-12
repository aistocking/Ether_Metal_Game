extends RigidBody2D

var _direction: Vector2
var _speed: float = 150
var _damage: int = 2
var _spawner: CharacterBody2D

@onready var _hit_box: Area2D = $EnemyHitBox
@onready var _collision_box: Area2D = $Physical
const _hit_fx: PackedScene = preload("res://Scenes/Effects/shot_effect.tscn")

func _ready():
	$Sprites.frame = randi_range(0,2)
	_hit_box.set_variables(_damage)
	$EnemyHitBox.set_collision(false)
	$EnemyHitBox.connect("was_parried", _reverse_towards_enemy)

func _physics_process(_delta):
	pass

func set_direction(vec: Vector2) -> void:
	linear_velocity = vec * _speed

func who_made_me(enemy: CharacterBody2D) -> void:
	_spawner = enemy

func _reverse_towards_enemy() -> void:
	set_direction(global_position.direction_to(_spawner.global_position))

func _spawn_wall_hit_effect() -> void:
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	hitFX.global_position = global_position
	get_parent().add_child(hitFX)

func _on_physical_body_entered(body):
	_spawn_wall_hit_effect()
