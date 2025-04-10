extends Node2D

@onready var _stage_bgm: AudioStream = preload("res://Sound/Music/Tundra_Theme.mp3")
@onready var _camera: Camera2D = $Main_Camera
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.change_music(_stage_bgm, 17.32)
	_camera.change_camera_limits($CameraBounds/BottomLeftPosition.global_position, $CameraBounds/TopRightPosition.global_position, 0, false)
	$Main_Camera/WholeScreenParticles/GPUParticles2D.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
