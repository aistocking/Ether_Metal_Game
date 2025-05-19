extends Control


const _text_box_texture: Texture2D = preload("res://Art/MiscUI/Menu_Box_Background.png")
const _text_box_texture_dark: Texture2D = preload("res://Art/MiscUI/Menu_Box_Background_Dark.png")
const _delete_texture_red: Texture2D = preload("res://Art/MiscUI/Delete_Text_Red.png")
const _delete_texture_red_dark: Texture2D = preload("res://Art/MiscUI/Delete_Text_Red_Dark.png")
const _delete_texture_normal: Texture2D = preload("res://Art/MiscUI/Delete_Text.png")
const _delete_texture_normal_dark: Texture2D = preload("res://Art/MiscUI/Delete_Text_Dark.png")

const _CHARGE_SHOT_SCENE: PackedScene = preload("res://Scenes/Player/Attacks/plasma_shot.tscn")
const _charge_shot_sfx: AudioStream = preload("res://Sound/BusterChargeShot.wav")
const _ui_move_sfx: AudioStream = preload("res://Sound/UIMove.wav")

@onready var _sfx_player: EffectAudioPlayer = $EffectAudioPlayer
@onready var _delete_button: TextureButton = $Delete

var _first_time: bool = true
var _slot1_filled: bool = false
var _slot2_filled: bool = false
var _slot3_filled: bool = false


func _ready():
	$SaveSlot1.grab_focus()
	Global.change_music(load("res://Sound/Music/Options_Music.mp3"))



#On pressed logic
func _on_save_slot_1_pressed():
	if _delete_button.button_pressed == true:
		return
	_slot1_filled = true
	$AnimationPlayer.play("Slot1_New")
	_sfx_player.play_sound(_charge_shot_sfx)
	var instance = _CHARGE_SHOT_SCENE.instantiate()
	instance.global_position = $Liliya1/BusterPosition.global_position
	instance.set_direction(Vector2(1, 0))
	add_child(instance)
	await $AnimationPlayer.animation_finished
	Global.change_scene("res://Scenes/Misc/menus/stage_select.tscn")

func _on_save_slot_2_pressed():
	if _delete_button.button_pressed == true:
		return
	Global.change_scene("res://Scenes/Misc/menus/stage_select.tscn")

func _on_save_slot_3_pressed():
	if _delete_button.button_pressed == true:
		return
	Global.change_scene("res://Scenes/Misc/menus/stage_select.tscn")

func _on_exit_pressed():
	Global.change_scene("res://Scenes/Misc/menus/main_menu.tscn")

func _on_delete_pressed():
	if _delete_button.button_pressed == true:
		_delete_button.texture_normal = _delete_texture_red_dark
		_delete_button.texture_focused = _delete_texture_red
	else:
		_delete_button.texture_normal = _delete_texture_normal_dark
		_delete_button.texture_focused = _delete_texture_normal



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
