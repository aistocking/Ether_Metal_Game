extends Node2D

var _player
var _camera
@export var bottomLeftBound: Marker2D
@export var topRightBound: Marker2D

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
		get_tree().paused = true
		$AnimationPlayer.play("Unseal")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Open")
		await $AnimationPlayer.animation_finished
		_player.velocity.x = 45
		_setCameraBounds(1)
		await get_tree().create_timer(1).timeout
		$AnimationPlayer.play("Open", -1, -1.5, true)
		await $AnimationPlayer.animation_finished
		$TransitionTrigger/CollisionShape2D.disabled = true
		$BlockingCollision/CollisionShape2D.disabled = false
		$AnimationPlayer.play("Lock")
		await $AnimationPlayer.animation_finished
		_player.exitCutsceneState()
		get_tree().paused = false

func _setCameraBounds(transition_time: float) -> void:
	_camera.change_camera_limits(bottomLeftBound.global_position, topRightBound.global_position, transition_time)

func _on_stopping_trigger_body_entered(body):
	if body == _player:
		_player.velocity = Vector2.ZERO
