extends Node2D

var _player
var _camera
@onready var _audio_player: EffectAudioPlayer = $EffectAudioPlayer
@onready var _open_sound: AudioStream = load("res://Sound/Door Open.wav")
@onready var _close_sound: AudioStream = load("res://Sound/Door Close.wav")
@onready var _bottom_left_marker: Marker2D = $BottomLeftCameraBound
@onready var _top_right_marker: Marker2D = $TopRightCameraBound

# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_camera = get_tree().get_first_node_in_group("Camera")
	


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
		_player.velocity.x = 50
		_player.player_animations.play()
		_camera.change_camera_limits(_bottom_left_marker.global_position, _top_right_marker.global_position, 1.3, true)
		await get_tree().create_timer(1.3).timeout
		_player.player_animations.play("Idle")
		_player.velocity.x = 0
		_player.velocity.y = ProjectSettings.get_setting("physics/2d/default_gravity")
		_audio_player.play_sound(_close_sound)
		$AnimationPlayer.play("Open", -1, -2, true)
		await $AnimationPlayer.animation_finished
		$TransitionTrigger/CollisionShape2D.disabled = true
		$BlockingCollision/CollisionShape2D.disabled = false
		$AnimationPlayer.play("Lock")
		await $AnimationPlayer.animation_finished
		Global.MusicPlayer.volume_db = Global.get_music_volume()
		_player.exitCutsceneState()
		get_tree().paused = false
