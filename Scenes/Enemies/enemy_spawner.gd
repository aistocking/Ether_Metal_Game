@tool
class_name EnemySpawner
extends Marker2D

@export var enemy: PackedScene:
	set(new_enemy):
		if new_enemy != enemy:
			enemy = new_enemy
			_on_enemy_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint() && enemy != null:
		_spawn()
	else:
		await get_tree().create_timer(1).timeout
		_spawn()

func _on_enemy_changed() -> void:
	for child in get_children():
		child.free()
	_spawn()
	
func _spawn() -> void:
	var instance = enemy.instantiate()
	call_deferred("add_child", instance)
	if not Engine.is_editor_hint():
		instance.connect("died", _spawn)
