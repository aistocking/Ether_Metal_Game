extends CanvasLayer

signal fade_finished

func play_fade(fade_in: bool) -> void:
	if fade_in == true:
		$AnimationPlayer.play("Fade_In")
	else:
		$AnimationPlayer.play("Fade_Out")
