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

var music_volume := -20.0
var _effect_volume := -20.0

signal effect_volume_changed

func _ready() -> void:
	MusicPlayer.volume_db = music_volume

func change_music(path: String) -> void:
	MusicPlayer.volume_db = music_volume
	MusicPlayer.stop()
	MusicPlayer.set_stream(load(path))
	MusicPlayer.play()

func get_effect_volume() -> float:
	return _effect_volume

func set_effect_volume(volume: float) -> void:
	_effect_volume = volume
	effect_volume_changed.emit()

func defeat_boss(boss: Bosses) -> void:
	if _defeated_bosses[boss] == true:
		push_error("Ruh roh, boss is already labled defeated")
	else:
		_defeated_bosses[boss] = true

func acquire_armor(armor: Armors) -> void:
	if _acquired_armors[armor] == true:
		push_error("Ruh roh, armor is already labled acquired")
	else:
		_acquired_armors[armor] = true

func acquire_heart_tank(heart_tank: HeartTanks) -> void:
	if _acquired_tanks[heart_tank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		_acquired_tanks[heart_tank] = true

func acquire_charge_capacitor(cap: ChargeCapacitors) -> void:
	if _acquired_charge_capacitors[cap] == true:
		push_error("Ruh roh, capacitor is already labled acquired")
	else:
		_acquired_charge_capacitors[cap] = true

func acquire_ether_tank(ether_tank: EtherTanks) -> void:
	if _acquired_ether_tanks[ether_tank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		_acquired_ether_tanks[ether_tank] = true

func save_game() -> void:
	pass

func load_game() -> void:
	pass
