extends Node

@onready var MusicPlayer: AudioStreamPlayer = get_node("/root/BgmPlayer")

enum Bosses { Boss1, Boss2, Boss3, Boss4, Boss5, Boss6, Boss7, Boss8 }
var _defeated_bosses: Array[bool] = [false, false, false, false, false, false, false, false]
enum Armors { Head, Chest, Arms, Legs }
var _acquired_armors: Array[bool] = [false, false, false, false]
enum HeartTanks { Tank1, Tank2, Tank3, Tank4, Tank5, Tank6, Tank7, Tank8 }
var _acquired_tanks: Array[bool] = [false, false, false, false, false, false, false, false]
enum ChargeCapacitors { Cap1, Cap2, Cap3, Cap4 }
var _acquired_charge_capacitors: Array[bool] = [false, false, false, false]
enum EtherTanks { ETank1, ETank2 }
var _acquired_ether_tanks: Array[bool] = [false, false]

var music_volume : float = -20
var _effect_volume : float = -20

signal effect_volume_changed

func _ready():
	MusicPlayer.volume_db = music_volume

func changeMusic(path : String):
	MusicPlayer.volume_db = music_volume
	MusicPlayer.stop()
	MusicPlayer.set_stream(load(path))
	MusicPlayer.play()

func get_effect_volume():
	return _effect_volume

func set_effect_volume(volume):
	_effect_volume = volume
	effect_volume_changed.emit()

func defeatBoss(bossname : Bosses):
	if _defeated_bosses[bossname] == true:
		push_error("Ruh roh, boss is already labled defeated")
	else:
		_defeated_bosses[bossname] = true

func acquireArmor(armorpart : Armors):
	if _acquired_armors[armorpart] == true:
		push_error("Ruh roh, armor is already labled acquired")
	else:
		_acquired_armors[armorpart] = true

func acquireHeartTank(hearttank : HeartTanks):
	if _acquired_tanks[hearttank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		_acquired_tanks[hearttank] = true

func acquireChargeCapacitor(cap : ChargeCapacitors):
	if _acquired_charge_capacitors[cap] == true:
		push_error("Ruh roh, capacitor is already labled acquired")
	else:
		_acquired_charge_capacitors[cap] = true

func acquireEtherTank(ethertank : EtherTanks):
	if _acquired_ether_tanks[ethertank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		_acquired_ether_tanks[ethertank] = true

func saveGame():
	pass

func loadGame():
	pass
