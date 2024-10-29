extends Node2D

var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_transition_trigger_body_entered(body):
	if body == _player:
		$AnimationPlayer.play("Unseal")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Open")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Open", -1, -1.5, true)
		await $AnimationPlayer.animation_finished
		$BlockingCollision/CollisionShape2D.disabled = false
		$AnimationPlayer.play("Lock")
		await $AnimationPlayer.animation_finished
