extends CanvasLayer

@onready var currentText = $MarginContainer/HSplitContainer/Box/MarginContainer/Text

@onready var tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	resetText()


func newText(text):
	resetText()
	currentText = text
	tween.tween_property(currentText, "Visible Ratio", 0, 1)

func resetText():
	currentText.text = ""
	currentText.visible_ratio = 0

func skipText():
	currentText.visible_ratio = 1
