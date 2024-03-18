extends Node2D

@export var GhostLevel : float
@export var SpeedScale : float
@onready var AnimPlayer = $ReadyIntro
# Called when the node enters the scene tree for the first time.
func _ready():
	AnimPlayer.current_animation = "intro"
	AnimPlayer.stop()
	modulate.a = GhostLevel
	AnimPlayer.speed_scale = SpeedScale

func play():
	AnimPlayer.play("intro")
