extends Node2D

var _spawn_location: Vector2
@export var _damage: int
@export var _direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	position = _spawn_location


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
