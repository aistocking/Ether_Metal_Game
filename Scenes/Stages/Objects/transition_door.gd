extends Node2D

var _player
var _camera
@export var is_boss_door: bool = false
@export var wait_for_cutscene: bool = false
@export var enter_from_right: bool = false
@export var enter_from_above: bool = false
@onready var _audio_player: EffectAudioPlayer = $EffectAudioPlayer
@onready var _open_sound: AudioStream = load("res://Sound/Door Open.wav")
@onready var _close_sound: AudioStream = load("res://Sound/Door Close.wav")
@onready var _bottom_left_marker: Marker2D = $BottomLeftCameraBound
@onready var _top_right_marker: Marker2D = $TopRightCameraBound
const WARNING_SCENE: PackedScene = preload("res://Scenes/Misc/cutscenes/warning_cutscene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_camera = get_tree().get_first_node_in_group("Camera")
	if enter_from_above and enter_from_right:
		push_error("Door cannot be multiple entrance types at once")
	if is_boss_door and wait_for_cutscene:
		push_error("Boss doors already wait for cutscene trigger")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_transition_trigger_body_entered(body):
	if body == _player:
		_player.enterCutsceneState()
		Global.MusicPlayer.volume_db -= 5
		get_tree().paused = true
		_audio_player.play_sound(_open_sound)
		$AnimationPlayer.play("Unseal")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Open")
		await $AnimationPlayer.animation_finished
		if enter_from_right:
			_player.velocity.x = -50
		elif enter_from_above:
			_player.velocity.y = 50
		else:
			_player.velocity.x = 50
		_player.player_animations.play()
		_camera.change_camera_limits(_bottom_left_marker.global_position, _top_right_marker.global_position, 1.3, true)
		await get_tree().create_timer(1.3).timeout
		$TransitionTrigger/CollisionShape2D.disabled = true
		$BlockingCollision/CollisionShape2D.disabled = false
		_player.player_animations.play("Idle")
		_player.velocity.x = 0
		_player.velocity.y = 0
		_audio_player.play_sound(_close_sound)
		$AnimationPlayer.play("Open", -1, -2, true)
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Lock")
		await $AnimationPlayer.animation_finished
		if is_boss_door:
			var instance = WARNING_SCENE.instantiate()
			add_child(instance)
			await get_tree().create_timer(5.3).timeout
			instance.stop()
		else:
			Global.MusicPlayer.volume_db = Global.get_music_volume()
			_player.exitCutsceneState()
			get_tree().paused = false
