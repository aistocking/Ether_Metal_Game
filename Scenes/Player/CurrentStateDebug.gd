extends Label

var heat = 1

func setText(txt: String) -> void:
	heat = max(0, heat - 0.2)
	self.text = txt

func _process(_delta):
	add_theme_color_override("font_color", Color(1, heat, heat))

func _physics_process(_delta):
	heat = min(1, heat + 0.06)
