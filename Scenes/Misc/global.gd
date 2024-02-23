extends Node

@onready var MusicPlayer = get_node("/root/BgmPlayer")

var DefeatedBosses =  [false, false, false, false, false, false, false, false]
var AcquiredArmors = [false, false, false, false]

func _ready():
	pass

func changeMusic(path : String):
	MusicPlayer.stop()
	MusicPlayer.set_stream(load(path))
	MusicPlayer.play()

func saveGame():
	pass

func loadGame():
	pass
