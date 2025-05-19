extends Area2D

@export var _enemy: PackedScene
@export var _rotation: int = 0

var _current_enemy: BasicEnemy

func _ready():
	pass # Replace with function body.

func _spawn_enemy() -> void:
	_current_enemy = _enemy.instantiate()
	_current_enemy.rotation = _rotation
	add_child(_current_enemy)

func _on_area_entered(area):
	if area.is_in_group("Spawn Area") and !is_instance_valid(_current_enemy):
		_spawn_enemy()
		
