extends Node2D

@onready var _stage_bgm: AudioStream = preload("res://Sound/Music/Tundra_Theme.mp3")
@onready var _camera: Camera2D = $Main_Camera
@onready var _enemy: PackedScene = preload("res://Scenes/Enemies/base_enemy.tscn")

func _ready():
	Global.change_music(_stage_bgm, 17.32)
	_camera.change_camera_limits($Camera_Triggers/CameraBounds1/BottomLeftPosition.global_position, $Camera_Triggers/CameraBounds1/TopRightPosition.global_position, 0, false)
	$Main_Camera/WholeScreenParticles/GPUParticles2D.emitting = true
	_spawn_enemy()
	$BossTransitionDoor.is_boss_door = true

func _process(delta):
	pass

func _spawn_enemy() -> void:
	await get_tree().create_timer(3).timeout
	if $Enemies/EnemyRespawnPoint.get_child_count() == 0:
		var instance1 = _enemy.instantiate()
		$Enemies/EnemyRespawnPoint.add_child(instance1)
		instance1.connect("died", _spawn_enemy)
