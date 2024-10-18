extends Node2D

var spent: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("Lock")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Twist")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Open")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("Open")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Twist")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Lock")
	await $AnimationPlayer.animation_finished
