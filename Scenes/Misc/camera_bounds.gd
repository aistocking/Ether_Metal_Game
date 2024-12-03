extends Node2D

@export var transition_time: float = 1.0
@export var instant_start_trigger: bool = false
@export var door_transition: bool = false

var _camera
var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	_camera = get_tree().get_first_node_in_group("Camera")
	_player = get_tree().get_first_node_in_group("Player")
	if instant_start_trigger == true:
		_camera.change_camera_limits($BottomLeftPosition.global_position, $TopRightPosition.global_position, 0, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_trigger_body_entered(body):
	if body == _player:
		_camera.change_camera_limits($BottomLeftPosition.global_position, $TopRightPosition.global_position, transition_time, false)


func _on_start_trigger_body_entered(body):
	if body == _player:
		_camera.change_camera_limits($BottomLeftPosition.global_position, $TopRightPosition.global_position, transition_time, false)
