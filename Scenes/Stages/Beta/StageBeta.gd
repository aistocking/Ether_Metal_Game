extends Node2D

var DialogueBoxResource = preload("res://Scenes/Misc/TextBox.tscn")

func _ready():
	Global.changeMusic("res://Sound/Music/06_Opening Stage X.mp3")
	RenderingServer.set_default_clear_color(Color(0,0,0))

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	add_child(DialogueBoxInst)
	$Area2D.queue_free()
