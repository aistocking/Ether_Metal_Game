extends CanvasLayer

var main_tween = create_tween()
var footer_tween = create_tween()
var header_tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.stop_music()
	main_tween.set_loops()
	main_tween.chain().tween_property($Text, "modulate", Color.WHITE, 0.5)
	main_tween.tween_property($Text, "modulate", Color.DARK_RED, 0.5)
	footer_tween.set_loops()
	footer_tween.chain().tween_property($Footer, "modulate", Color.WHITE, 0.5)
	footer_tween.tween_property($Footer, "modulate", Color.DARK_RED, 0.5)
	header_tween.set_loops()
	header_tween.chain().tween_property($Header, "modulate", Color.WHITE, 0.5)
	header_tween.tween_property($Header, "modulate", Color.DARK_RED, 0.5)
	main_tween.play()
	footer_tween.play()
	header_tween.play()

func stop() -> void:
	$AnimationPlayer.play("Stop")
