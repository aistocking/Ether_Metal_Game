extends AnimatedSprite2D


@onready var SFXPlayer = $SFXPlayer
var _explosion_sfx = preload("res://Sound/MediumExplosion.wav")

func _ready():
	SFXPlayer.play_sound(_explosion_sfx)


func _on_animation_finished():
	queue_free()
