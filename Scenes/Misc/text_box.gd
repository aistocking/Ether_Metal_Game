class_name TextBox
extends CanvasLayer

@onready var currentText = $MarginContainer/HSplitContainer/Box/MarginContainer/Text

var tween

@onready var Player = get_tree().get_first_node_in_group("Player")

var readRate : float = 0
var counter : int = 0
var curText : String
var text0 : String = "Why must reploids fight one another?"
var text1 : String = "I've had enough fighting!"
var text2 : String = "......god X7 was bad."


func _ready():
	Player.changePlayerControl(false)
	playText()

func _process(delta):
	currentText.visible_ratio = readRate

func _input(event):
	if Input.is_action_just_pressed("Face Buttons"):
		if readRate < 1:
			skipText()
			return
		playText()

func playText():
	resetText()
	match counter:
		0:
			currentText.text = text0
		1:
			currentText.text = text1
		2:
			currentText.text = text2
		3:
			endDialogue()
	counter += 1
	tween = get_tree().create_tween()
	tween.tween_property(self, "readRate", 1, 1)



func resetText():
	currentText.text = ""
	readRate = 0

func skipText():
	tween.kill()
	readRate = 1

func endDialogue():
	Player.changePlayerControl(true)
	queue_free()
