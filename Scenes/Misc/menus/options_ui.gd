extends Control

@onready var _music: Slider = $CenterContainer/HOptionsContainer/RightVBox/MusicVolume
@onready var _effect: Slider = $CenterContainer/HOptionsContainer/RightVBox/EffectVolume
@onready var _sfx_player: EffectAudioPlayer = $EffectAudioPlayer

var _first_time: bool = true

const OPTIONS_MUSIC: AudioStream = preload("res://Sound/Music/Options_Music.mp3")
const _cursor_move_sfx: AudioStream = preload("res://Sound/MMX1 - Cursor Move.wav")
const _cursor_accept_sfx: AudioStream = preload("res://Sound/UIConfirm.wav")

const _dots_dark: Texture2D = preload("res://Art/MiscUI/Dots_Spacers_Dark.png")
const _dots_bright: Texture2D = preload("res://Art/MiscUI/Dots_Spacers.png")

const _slider_bright: Texture2D = preload("res://Art/MiscUI/Slider.png")
const _slider_dark: Texture2D = preload("res://Art/MiscUI/Slider_Dark.png")

func _ready() -> void:
	Global.manual_fade(true)
	$CenterContainer/HOptionsContainer/LeftVBox/ScaleText.grab_focus()
	Global.change_music(OPTIONS_MUSIC, 0.0)
	_music.value = Global.get_music_volume()
	_effect.value = Global.get_effect_volume()
	_match_scale()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.x = 0
	else:
		$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.x = 12
	if Global.rapid_fire == false:
		$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.x = 0
	else:
		$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.x = 12


func _on_music_volume_value_changed(value: float) -> void:
	Global.set_music_volume(value)


func _on_effect_volume_value_changed(value: float) -> void:
	Global.set_effect_volume(value)

func _match_scale() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.x = 24
	else:
		match get_window().size.x:
			480:
				$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.x = 0
			960:
				$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.x = 8
			1920:
				$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.x = 16

func _increase_scale() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		match get_window().size.x:
			480:
				get_window().size = Vector2(960, 448)
			960:
				get_window().size = Vector2(1920, 896)
			1920:
				get_window().size = Vector2(480, 224)
	_match_scale()


# On pressed functions
func _on_scale_text_pressed():
	_increase_scale()

func _on_exit_text_pressed():
	Global.change_scene("previous_scene")

func _on_fullscreen_text_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.x = 12
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.x = 0
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_match_scale()
z
func _on_controls_text_pressed():
	pass # Replace with function body.

func _on_rapid_fire_text_pressed():
	if Global.rapid_fire == true:
		$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.x = 0
		Global.rapid_fire = false
	else:
		$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.x = 12
		Global.rapid_fire = true


# On focus enter logic
func _on_scale_text_focus_entered():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots1.texture = _dots_bright
	$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.y = 0
	$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers2.texture.region.position.y = 0
	if _first_time == true:
		_first_time = false
	else:
		_sfx_player.play_sound(_cursor_move_sfx)
	
func _on_fullscreen_text_focus_entered():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots2.texture = _dots_bright
	$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.y = 0
	_sfx_player.play_sound(_cursor_move_sfx)
	
func _on_music_volume_focus_entered():
	$CenterContainer/HOptionsContainer/RightVBox/MusicVolume.get_theme_stylebox("slider").texture = _slider_bright
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots3.texture = _dots_bright
	$CenterContainer/HOptionsContainer/LeftVBox/MusicVolumeText.texture.region.position.y = 0
	_sfx_player.play_sound(_cursor_move_sfx)

func _on_effect_volume_focus_entered():
	$CenterContainer/HOptionsContainer/RightVBox/EffectVolume.get_theme_stylebox("slider").texture = _slider_bright
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots4.texture = _dots_bright
	$CenterContainer/HOptionsContainer/LeftVBox/SFXVolumeText.texture.region.position.y = 0
	_sfx_player.play_sound(_cursor_move_sfx)

func _on_rapid_fire_text_focus_entered():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots5.texture = _dots_bright
	$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.y = 0
	_sfx_player.play_sound(_cursor_move_sfx)

func _on_controls_text_focus_entered():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots6.texture = _dots_bright
	$CenterContainer/HOptionsContainer/RightVBox/CustomizeText.texture.region.position.y = 0
	_sfx_player.play_sound(_cursor_move_sfx)

func _on_exit_text_focus_entered():
	_sfx_player.play_sound(_cursor_move_sfx)


# On focus exit logic
func _on_scale_text_focus_exited():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots1.texture = _dots_dark
	$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers.texture.region.position.y = 12
	$CenterContainer/HOptionsContainer/RightVBox/HBoxContainer/ScaleNumbers2.texture.region.position.y = 9

func _on_fullscreen_text_focus_exited():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots2.texture = _dots_dark
	$CenterContainer/HOptionsContainer/RightVBox/CheckBox.texture.region.position.y = 14

func _on_music_volume_focus_exited():
	$CenterContainer/HOptionsContainer/RightVBox/MusicVolume.get_theme_stylebox("slider").texture = _slider_dark
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots3.texture = _dots_dark
	$CenterContainer/HOptionsContainer/LeftVBox/MusicVolumeText.texture.region.position.y = 12

func _on_effect_volume_focus_exited():
	$CenterContainer/HOptionsContainer/RightVBox/EffectVolume.get_theme_stylebox("slider").texture = _slider_dark
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots4.texture = _dots_dark
	$CenterContainer/HOptionsContainer/LeftVBox/SFXVolumeText.texture.region.position.y = 12

func _on_rapid_fire_text_focus_exited():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots5.texture = _dots_dark
	$CenterContainer/HOptionsContainer/RightVBox/RFCheckBox.texture.region.position.y = 14

func _on_controls_text_focus_exited():
	$CenterContainer/HOptionsContainer/MiddleVBox/Dots6.texture = _dots_dark
	$CenterContainer/HOptionsContainer/RightVBox/CustomizeText.texture.region.position.y = 12
