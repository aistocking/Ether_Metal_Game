extends Node

@onready var MusicPlayer = get_node("/root/BgmPlayer")

enum Bosses {Boss1, Boss2, Boss3, Boss4, Boss5, Boss6, Boss7, Boss8}
var DefeatedBosses =  [false, false, false, false, false, false, false, false]
enum Armors {Head, Chest, Arms, Legs}
var AcquiredArmors = [false, false, false, false]
enum HeartTanks {Tank1, Tank2, Tank3, Tank4, Tank5, Tank6, Tank7, Tank8}
var AcquiredTanks =  [false, false, false, false, false, false, false, false]
enum ChargeCapacitors {Cap1, Cap2, Cap3, Cap4}
var AcquiredChargeCapacitors = [false, false, false, false]
enum EtherTanks {ETank1, ETank2}
var AcquiredEtherTanks = [false, false]

var MusicVolume : float = -20
var SFXVolume : float = -20

func _ready():
	MusicPlayer.volume_db = MusicVolume

func changeMusic(path : String):
	MusicPlayer.volume_db = MusicVolume
	MusicPlayer.stop()
	MusicPlayer.set_stream(load(path))
	MusicPlayer.play()

func defeatBoss(bossname : Bosses):
	if DefeatedBosses[bossname] == true:
		push_error("Ruh roh, boss is already labled defeated")
	else:
		DefeatedBosses[bossname] = true

func acquireArmor(armorpart : Armors):
	if AcquiredArmors[armorpart] == true:
		push_error("Ruh roh, armor is already labled acquired")
	else:
		AcquiredArmors[armorpart] = true

func acquireHeartTank(hearttank : HeartTanks):
	if AcquiredTanks[hearttank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		AcquiredTanks[hearttank] = true

func acquireChargeCapacitor(cap : ChargeCapacitors):
	if AcquiredChargeCapacitors[cap] == true:
		push_error("Ruh roh, capacitor is already labled acquired")
	else:
		AcquiredChargeCapacitors[cap] = true

func acquireEtherTank(ethertank : EtherTanks):
	if AcquiredEtherTanks[ethertank] == true:
		push_error("Ruh roh, tank is already labled acquired")
	else:
		AcquiredEtherTanks[ethertank] = true

func saveGame():
	pass

func loadGame():
	pass
