extends Node2D

var DialogueBoxResource = preload("res://Scenes/Misc/TextBox.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0,0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	add_child(DialogueBoxInst)
	$Area2D.queue_free()
