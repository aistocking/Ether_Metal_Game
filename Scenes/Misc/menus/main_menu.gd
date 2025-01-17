extends Control

signal shot_finished
signal fade_finished

const _CHARGE_SHOT_SCENE: PackedScene = preload("res://Scenes/Effects/plasma_shot.tscn")
const _charge_shot_sfx: AudioStream = preload("res://Sound/BusterChargeShot.wav")
const _ui_move_sfx: AudioStream = preload("res://Sound/UIMove.wav")

var _first_time: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Start.grab_focus()
	$PlayerSprite.position = Vector2(139, 155)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func lily_shot_animation() -> void:
	$EffectAudioPlayer.play_sound(_charge_shot_sfx)
	$AnimationPlayer.play("LilyShot")
	var instance = _CHARGE_SHOT_SCENE.instantiate()
	instance.global_position = $PlayerSprite/BusterPosition.global_position
	instance.set_direction(Vector2(1, 0))
	add_child(instance)

func _on_start_pressed() -> void:
	$CenterContainer/Start.release_focus()
	lily_shot_animation()
	await shot_finished
	Global.change_scene("res://Scenes/Misc/menus/save_select_menu.tscn")


func _on_quit_pressed() -> void:
	$CenterContainer/Quit.release_focus()
	lily_shot_animation()
	await shot_finished
	Global.manual_fade(false)
	await Global.cutscene_stop
	get_tree().quit()


func _on_options_pressed() -> void:
	$CenterContainer/Options.release_focus()
	lily_shot_animation()
	await shot_finished
	Global.change_scene("res://Scenes/Misc/menus/options_UI.tscn")


func _on_start_focus_entered() -> void:
	$PlayerSprite.position.y = $CenterContainer/Start.global_position.y + 7
	if _first_time == true:
		_first_time = false
	else:
		$EffectAudioPlayer.play_sound(_ui_move_sfx)


func _on_options_focus_entered() -> void:
	$PlayerSprite.position.y = $CenterContainer/Options.global_position.y + 7
	$EffectAudioPlayer.play_sound(_ui_move_sfx)


func _on_quit_focus_entered() -> void:
	$PlayerSprite.position.y = $CenterContainer/Quit.global_position.y + 7
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
