class_name TextBox
extends CanvasLayer


signal advanced

@onready var _current_text: Label = %DialogLabel
@onready var _player: PlayerCharacter = get_tree().get_first_node_in_group("Player")

var _tween: Tween
var _read_rate: float = 0


func _ready() -> void:
	_player.change_player_control(false)
	_say("Why must reploids fight one another?")
	await advanced
	_say("I've had enough fighting!")
	await advanced
	_say("......god X7 was bad.")
	await advanced
	_end_dialog()


func _process(_delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Face Buttons"):
		if _current_text.visible_ratio < 1:
			_display_full_text()
			return
		advanced.emit()


func _say(text: String) -> void:
	_current_text.visible_ratio = 0
	_current_text.text = text
	_tween = self.create_tween()
	_tween.tween_property(_current_text, "visible_ratio", 1, 1)


func _display_full_text() -> void:
	_tween.kill()
	_current_text.visible_ratio = 1


func _end_dialog() -> void:
	_player.change_player_control(true)
	queue_free()
