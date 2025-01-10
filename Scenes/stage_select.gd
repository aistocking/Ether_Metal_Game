extends Control

const _music: AudioStream = preload("res://Sound/Music/05_Stage Select.mp3")
const _ui_move_sfx: AudioStream = preload("res://Sound/UIMove.wav")

var _first_time: bool = true
var _tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/MainContainer/BottomStages/SvaGroup/Svarog.grab_focus()
	Global.change_music(_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#On pressed logic
func _on_perun_pressed() -> void:
	pass

func _on_volos_pressed() -> void:
	pass

func _on_svarog_pressed():
	Global.change_scene("res://Scenes/Stages/Beta/stage_beta.tscn")

func _on_marena_pressed():
	Global.change_scene("res://Scenes/Stages/Alpha/stage_alpha.tscn")



#On focus entered logic
func _on_svarog_focus_entered() -> void:
	if _first_time == true:
		_first_time = false
	else:
		$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.play()
	$SvarogMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/SvaGroup/Svarog, "position", Vector2(-5, -3), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/SvaGroup/Svarog, "position", Vector2(0, 0), 0.6)

func _on_marena_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.play()
	$MoranaMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/MorGroup/Marena, "position", Vector2(9, -4), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/MorGroup/Marena, "position", Vector2(10, 0), 0.6)

func _on_belobog_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.play()
	$BelobogMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/BelGroup/Belobog, "position", Vector2(11, -4), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/BelGroup/Belobog, "position", Vector2(10, 0), 0.6)

func _on_yaryla_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.play()
	$YarylaMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/YarGroup/Yaryla, "position", Vector2(5, -3), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/BottomStages/YarGroup/Yaryla, "position", Vector2(0, 0), 0.6)

func _on_perun_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.play()
	$PerunMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/TopStages/PGroup/Perun, "position", Vector2(-5, 3), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/TopStages/PGroup/Perun, "position", Vector2(0, 0), 0.6)

func _on_mokosh_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.play()
	$MokoshMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/TopStages/MokGroup/Mokosh, "position", Vector2(9, 4), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/TopStages/MokGroup/Mokosh, "position", Vector2(10, 0), 0.6)

func _on_svetovit_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.play()
	$SvetovitMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/TopStages/SvetGroup/Svetovit, "position", Vector2(11, 4), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/TopStages/SvetGroup/Svetovit, "position", Vector2(10, 0), 0.6)

func _on_volos_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.play()
	$VolosMarker.play()
	_tween = create_tween().set_loops()
	_tween.tween_property($MarginContainer/MainContainer/TopStages/VolGroup/Volos, "position", Vector2(5, 3), 0.6)
	_tween.tween_property($MarginContainer/MainContainer/TopStages/VolGroup/Volos, "position", Vector2(0, 0), 0.6)

func _on_player_options_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)

func _on_intro_stage_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)



#On focus exited logic
func _on_svarog_focus_exited():
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.frame = 0
	$SvarogMarker.stop()
	$SvarogMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/BottomStages/SvaGroup/Svarog.position = Vector2(0, 0)


func _on_marena_focus_exited():
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.frame = 0
	$MoranaMarker.stop()
	$MoranaMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/BottomStages/MorGroup/Marena.position = Vector2(10, 0)


func _on_belobog_focus_exited():
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.frame = 0
	$BelobogMarker.stop()
	$BelobogMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/BottomStages/BelGroup/Belobog.position = Vector2(10, 0)


func _on_yaryla_focus_exited():
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.frame = 0
	$YarylaMarker.stop()
	$YarylaMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/BottomStages/YarGroup/Yaryla.position = Vector2(0, 0)


func _on_perun_focus_exited():
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.frame = 0
	$PerunMarker.stop()
	$PerunMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/TopStages/PGroup/Perun.position = Vector2(0, 0)


func _on_mokosh_focus_exited():
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.frame = 0
	$MokoshMarker.stop()
	$MokoshMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/TopStages/MokGroup/Mokosh.position = Vector2(10, 0)


func _on_svetovit_focus_exited():
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.frame = 0
	$SvetovitMarker.stop()
	$SvetovitMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/TopStages/SvetGroup/Svetovit.position = Vector2(10, 0)


func _on_volos_focus_exited():
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.frame = 0
	$VolosMarker.stop()
	$VolosMarker.frame = 0
	_tween.kill()
	$MarginContainer/MainContainer/TopStages/VolGroup/Volos.position = Vector2(0, 0)
