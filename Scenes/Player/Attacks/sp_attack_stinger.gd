class_name Stinger
extends Node2D

@onready var timer: Timer = $DeathTimer

var _damage: int = 5
var _stun_damage: int = 5
var _power: float = -1
var _hit_direction: Vector2 = Vector2(1, 0)

signal hit
signal timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.connect("hit", _hit)
	$HitBox.set_variables(_damage, _stun_damage, _hit_direction, _power)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func face_left() -> void:
	scale.x = scale.x * -1
	_hit_direction = Vector2(-1, 0)

func _hit() -> void:
	emit_signal("hit")
	queue_free()


func die():
	emit_signal("timeout")
	queue_free()
