extends AnimatedSprite2D


@onready var SFXPlayer = $SFXPlayer
var ExplosionSFX = preload("res://Sound/MediumExplosion.wav")

func _ready():
	SFXPlayer.set_stream(ExplosionSFX)
	SFXPlayer.play()


func _process(_delta):
	pass


func _on_animation_finished():
	queue_free()
