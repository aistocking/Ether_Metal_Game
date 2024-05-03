extends Area2D

var Direction
var Speed = 1
var Damage = 6

@onready var SFXPlayer = $SFXPlayer
var HitSFX = preload("res://Sound/BusterShotHit.wav")

var tween

func _ready():
	SFXPlayer.volume_db = Global.SFXVolume
	SFXPlayer.set_stream(HitSFX)
	tween = get_tree().create_tween()
	tween.tween_property(self, "Speed", 12, .7)

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


func _on_body_entered(body):
	if(body.has_method("takeDamage")):
		SFXPlayer.play()
		body.takeDamage(Damage)


func _on_sfx_player_finished():
	queue_free()
