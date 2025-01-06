extends Node

@onready var MusicPlayer: AudioStreamPlayer = get_node("/root/BgmPlayer")


enum Bosses { Boss1, Boss2, Boss3, Boss4, Boss5, Boss6, Boss7, Boss8 }
var _defeated_bosses: Array[bool] = [false, false, false, false, false, false, false, false]
enum Armors { Head, Chest, Arms, Legs }
var _acquired_armors: Array[bool] = [false, false, false, false]
enum HeartTanks { Tank1, Tank2, Tank3, Tank4, Tank5, Tank6, Tank7, Tank8 }
var _acquired_health_tanks: Array[bool] = [false, false, false, false, false, false, false, false]
enum ChargeCapacitors { Cap1, Cap2, Cap3, Cap4 }
var _acquired_charge_capacitors: Array[bool] = [false, false, false, false]
enum EtherTanks { ETank1, ETank2 }
var _acquired_ether_tanks: Array[bool] = [false, false]

var _music_volume := -20.0
var _effect_volume := -20.0

var _current_music: AudioStream
var _previous_scene: String
var _current_scene: String

var rapid_fire: bool = false

signal cutscene_start
signal cutscene_stop
signal effect_volume_changed
signal music_volume_changed

func _ready() -> void:
	MusicPlayer.volume_db = _music_volume
	_current_scene = "res://Scenes/main_menu.tscn"

func change_scene(path: String) -> void:
	if path == "previous_scene":
		_current_scene = _previous_scene
	else:
		_previous_scene = _current_scene
		_current_scene = path
	get_tree().change_scene_to_file(_current_scene)

func debug_mode() -> void:
	for i in _acquired_health_tanks:
		i = true
	for i in _acquired_charge_capacitors:
		i = true

func change_music(song: AudioStream, time: float = 0.0) -> void:
	MusicPlayer.volume_db = _music_volume
	MusicPlayer.stop()
	MusicPlayer.set_stream(song)
	_current_music = song
	MusicPlayer.play(time)

func get_current_music() -> AudioStream:
	return _current_music

func get_effect_volume() -> float:
	return _effect_volume

func get_music_volume() -> float:
	return _music_volume

func set_effect_volume(volume: float) -> void:
	_effect_volume = volume
	effect_volume_changed.emit()

func set_music_volume(volume: float) -> void:
	_music_volume = volume
	MusicPlayer.volume_db = volume
	music_volume_changed.emit()

func get_heart_tank_number() -> int:
	var temp: int = 0
	for i: bool in _acquired_health_tanks:
		if i == true:
			temp += 1
	return temp

func get_charge_capacitor_number() -> int:
	var temp: int = 0
	for i: bool in _acquired_charge_capacitors:
		if i == true:
			temp += 1
	return temp

func set_current_stage(scene_path: String) -> void:
	_current_scene = scene_path

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
	if _acquired_health_tanks[heart_tank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		_acquired_health_tanks[heart_tank] = true

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

func reset_stage() -> void:
	get_tree().change_scene_to_file(_current_scene)

func save_game() -> void:
	pass

func load_game() -> void:
	pass
