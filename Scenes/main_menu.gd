extends Control

signal shot_finished
signal fade_finished

const _CHARGE_SHOT_SCENE: PackedScene = preload("res://Scenes/Effects/plasma_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func lily_shot_animation() -> void:
	$EffectAudioPlayer.stream = load("res://Sound/BusterChargeShot.wav")
	$AnimationPlayer.play("LilyShot")
	await shot_finished
	$AnimationPlayer.play("FadeOut")

func _on_start_pressed() -> void:
	$CenterContainer/Start.release_focus()
	lily_shot_animation()
	await fade_finished
	get_tree().change_scene_to_file("res://Scenes/stage_select.tscn")


func _on_quit_pressed() -> void:
	$CenterContainer/Quit.release_focus()
	lily_shot_animation()
	await fade_finished
	get_tree().quit()


func _on_options_pressed() -> void:
	$CenterContainer/Options.release_focus()
	lily_shot_animation()
	await fade_finished
	get_tree().change_scene_to_file("res://Scenes/options_ui.tscn")


func _on_start_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 155)
	$EffectAudioPlayer.play()


func _on_options_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 174)
	$EffectAudioPlayer.play()


func _on_quit_focus_entered() -> void:
	$PlayerSprite.position = Vector2(139, 193)
	$EffectAudioPlayer.play()
