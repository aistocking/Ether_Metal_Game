extends Control

const _music: AudioStream = preload("res://Sound/Music/05_Stage Select.mp3")
const _ui_move_sfx: AudioStream = preload("res://Sound/UIMove.wav")

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
	get_tree().change_scene_to_file("res://Scenes/Stages/Beta/stage_beta.tscn")

func _on_marena_pressed():
	get_tree().change_scene_to_file("res://Scenes/Stages/Alpha/stage_alpha.tscn")



#On focus entered logic
func _on_svarog_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.play()

func _on_marena_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.play()

func _on_belobog_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.play()

func _on_yaryla_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.play()

func _on_perun_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.play()

func _on_mokosh_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.play()

func _on_svetovit_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.play()

func _on_volos_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.play()

func _on_player_options_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)

func _on_intro_stage_focus_entered() -> void:
	$EffectAudioPlayer.play_sound(_ui_move_sfx)



#On focus exited logic
func _on_svarog_focus_exited():
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/SvaGroup/FrameLines.frame = 0


func _on_marena_focus_exited():
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/MorGroup/FrameLines.frame = 0


func _on_belobog_focus_exited():
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/BelGroup/FrameLines.frame = 0


func _on_yaryla_focus_exited():
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.stop()
	$MarginContainer/MainContainer/BottomStages/YarGroup/FrameLines.frame = 0


func _on_perun_focus_exited():
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/PGroup/FrameLines.frame = 0


func _on_mokosh_focus_exited():
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/MokGroup/FrameLines.frame = 0


func _on_svetovit_focus_exited():
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/SvetGroup/FrameLines.frame = 0


func _on_volos_focus_exited():
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.stop()
	$MarginContainer/MainContainer/TopStages/VolGroup/FrameLines.frame = 0
