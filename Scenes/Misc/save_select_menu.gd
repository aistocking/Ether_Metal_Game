extends Control


const _text_box_texture: Texture2D = preload("res://Art/MiscUI/Menu_Box_Background.png")
const _text_box_texture_dark: Texture2D = preload("res://Art/MiscUI/Menu_Box_Background_Dark.png")
const _ui_move_sfx: AudioStream = preload("res://Sound/UIMove.wav")

@onready var _sfx_player: EffectAudioPlayer = $EffectAudioPlayer
@onready var _delete_button: TextureButton = $Delete

var _first_time: bool = true


func _ready():
	$SaveSlot1.grab_focus()



#On pressed logic
func _on_save_slot_1_pressed():
	if _delete_button.button_pressed == true:
		pass

func _on_save_slot_2_pressed():
	pass # Replace with function body.

func _on_save_slot_3_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	pass # Replace with function body.

func _on_delete_pressed():
	pass # Replace with function body.



#On focus entered logic
func _on_save_slot_1_focus_entered():
	$MarginContainer/VBoxContainer/MenuBox1.texture = _text_box_texture
	$Liliya1.frame = 0
	if _first_time == true:
		_first_time = false
	else:
		_sfx_player.play_sound(_ui_move_sfx)

func _on_save_slot_2_focus_entered():
	$MarginContainer/VBoxContainer/MenuBox2.texture = _text_box_texture
	$Liliya2.frame = 0
	_sfx_player.play_sound(_ui_move_sfx)

func _on_save_slot_3_focus_entered():
	$MarginContainer/VBoxContainer/MenuBox3.texture = _text_box_texture
	$Liliya3.frame = 0
	_sfx_player.play_sound(_ui_move_sfx)

func _on_exit_focus_entered():
	_sfx_player.play_sound(_ui_move_sfx)

func _on_delete_focus_entered():
	_sfx_player.play_sound(_ui_move_sfx)


#On focus exited logic
func _on_save_slot_1_focus_exited():
	$MarginContainer/VBoxContainer/MenuBox1.texture = _text_box_texture_dark
	$Liliya1.frame = 3

func _on_save_slot_2_focus_exited():
	$MarginContainer/VBoxContainer/MenuBox2.texture = _text_box_texture_dark
	$Liliya2.frame = 3

func _on_save_slot_3_focus_exited():
	$MarginContainer/VBoxContainer/MenuBox3.texture = _text_box_texture_dark
	$Liliya3.frame = 3
