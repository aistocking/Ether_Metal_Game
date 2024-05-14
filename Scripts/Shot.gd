extends Area2D

var Direction
var Speed = 10
var Damage = 1

@onready var SFXPlayer = $SFXPlayer
var HitSFX = preload("res://Sound/BusterShotHit.wav")

func _ready():
	SFXPlayer.set_stream(HitSFX)

func _physics_process(_delta):
	position += Direction * Speed

func getDirection(vec):
	Direction = vec

func flip(val):
	$Sprites.flip_h = val

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if(area.has_method("takeDamage")):
		SFXPlayer.play()
		area.takeDamage(Damage)
		$Sprites.queue_free()
	else:
		queue_free()

func _on_body_entered(body):
	if(body.has_method("takeDamage")):
		SFXPlayer.play()
		body.takeDamage(Damage)
		$Sprites.queue_free()
	else:
		queue_free()


func _on_sfx_player_finished():
	queue_free()
