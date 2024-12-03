extends Node2D

@export var _speed: int = 55
@export var _delay: float = 1

@onready var _start: CollisionShape2D = $StopTrigger/Start
@onready var _end: CollisionShape2D = $StopTrigger/End
@onready var _rest_timer: Timer = $RestTimer
@onready var _platform: StaticBody2D = $Body
var _tween: Tween = self.create_tween()

var _forward: bool = true
var _direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	_rest_timer.start(_delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_platform.position += _direction * _speed * delta
	#_platform.move_and_collide(_direction * _speed)


func _on_rest_timer_timeout():
	if _forward:
		_direction = _platform.position.direction_to(_end.position)
	else:
		_direction = _platform.position.direction_to(_start.position)
	_forward = !_forward


func _on_stop_trigger_body_entered(body):
	_direction = Vector2.ZERO
	_rest_timer.start(_delay)
