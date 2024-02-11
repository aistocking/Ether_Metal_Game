extends Label

var heat = 1

func setText(text: String) -> void:
	heat = max(0, heat - 0.2)
	self.text = text

func _process(delta):
	add_theme_color_override("font_color", Color(1, heat, heat))

func _physics_process(delta):
	heat = min(1, heat + 0.06)
