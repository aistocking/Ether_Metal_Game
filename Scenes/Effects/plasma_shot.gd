extends Area2D

var Direction
var Speed = 10
var Damage = 6

@onready var SFXPlayer = $SFXPlayer
var HitSFX = preload("res://Sound/BusterShotHit.wav")

func _ready():
	SFXPlayer.set_stream(HitSFX)

func _physics_process(_delta):
	position += Direction * Speed * _delta

func getDirection(vec):
	Direction = vec

func flip(val):
	$Sprites.flip_h = val
