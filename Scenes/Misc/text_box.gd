class_name TextBox
extends CanvasLayer


signal advanced

@onready var _left_container = %LeftContainer
@onready var _left_portrait: AnimatedSprite2D = %LeftPortrait
@onready var _right_container = %RightContainer
@onready var _right_portrait: AnimatedSprite2D = %RightPortrait
@onready var _current_text: Label = %DialogLabel
@onready var _player: PlayerCharacter = get_tree().get_first_node_in_group("Player")

@onready var _audio_player: EffectAudioPlayer = $EffectAudioPlayer

var _tween: Tween
var _read_rate: float = 0

var _main_character: Character = load("res://Scenes/Player/main_character.tres")
var _zero_character: Character = load("res://Scenes/Player/zero_character.tres")



func _ready() -> void:
	# TODO: Move this into an exported property.
	# TODO: How do I tie the dialog (script) to the resources?
	_audio_player.stream = load("res://Sound/TextLetterFast.wav")
	_player.change_player_control(false)
	_left_display(_main_character)
	_left_mood("talking")
	_say("Armour?")
	await advanced
	_left_mood("talking")
	_say("Uhm, akshually its spelled armor")
	await advanced
	_left_mood("talking")
	_say("you're not a british")
	await advanced
	_right_display(_zero_character)
	_right_mood("talking")
	_say("This for your arms by the way.")
	await advanced
	_right_mood("talking")
	_say("Now git")
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
	_tween.connect("finished", _on_tween_finished)
	_audio_player.play()
	_tween.tween_property(_current_text, "visible_ratio", 1, 1)


func _left_display(character: Character = null, mood: String = "idle") -> void:
	_right_container.hide()
	_left_container.show()
	_left_portrait.sprite_frames = character.portrait
	_left_mood(mood)


func _left_mood(mood: String = "idle") -> void:
	_left_portrait.animation = mood
	_left_portrait.play()


func _right_display(character: Character = null, mood: String = "idle") -> void:
	_left_container.hide()
	_right_container.show()
	_right_portrait.sprite_frames = character.portrait
	_right_mood(mood)


func _right_mood(mood: String = "idle") -> void:
	_right_portrait.animation = mood
	_right_portrait.play()


func _display_full_text() -> void:
	_tween.kill()
	_on_tween_finished()
	_current_text.visible_ratio = 1


func _end_dialog() -> void:
	_player.change_player_control(true)
	queue_free()

func _on_tween_finished() -> void:
	_right_mood("idle")
	_left_mood("idle")
	_audio_player.stop()
