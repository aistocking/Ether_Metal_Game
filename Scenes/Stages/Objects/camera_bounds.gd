extends Node2D

@export var transition_time: float = 1.0
@export var instant_start_trigger: bool = false
@export var door_transition: bool = false

var _camera
var _player

func _ready():
	_camera = get_tree().get_first_node_in_group("Camera")
	_player = get_tree().get_first_node_in_group("Player")
	if instant_start_trigger == true:
		_camera.change_camera_limits($BottomLeftPosition.global_position, $TopRightPosition.global_position, 0, false)



func _on_area_trigger_body_entered(body):
	if body == _player:
		_camera.change_camera_limits($BottomLeftPosition.global_position, $TopRightPosition.global_position, transition_time, false)
