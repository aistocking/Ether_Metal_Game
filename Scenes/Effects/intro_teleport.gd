extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("CirclesIntro")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("BeamIn")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("CirclesIntro")
	await $AnimationPlayer.animation_finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
