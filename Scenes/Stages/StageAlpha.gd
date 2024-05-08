extends Node2D

var Player
var DialogueBoxResource = preload("res://Scenes/Misc/TextBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0,0,0))
	Player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	Player.PlyrStateMachine._cutscene()
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	add_child(DialogueBoxInst)
