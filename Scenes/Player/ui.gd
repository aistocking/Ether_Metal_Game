class_name Hud
extends CanvasLayer

var _player: PlayerCharacter

@onready var health_bar_container: Sprite2D = $WholeScreen/HealthBar/Container
@onready var first_health_bar: TextureProgressBar = $"WholeScreen/HealthBar/1stHealthBar"
@onready var second_health_bar: TextureProgressBar = $"WholeScreen/HealthBar/2ndHealthBar"

@onready var ChargePellet1: TextureProgressBar = $"WholeScreen/ChargeBar/1stPellet/Pellet"
@onready var ChargePellet2: TextureProgressBar = $"WholeScreen/ChargeBar/2ndPellet/Pellet"
@onready var ChargePellet3: TextureProgressBar = $"WholeScreen/ChargeBar/3rdPellet/Pellet"
@onready var ChargePellet4: TextureProgressBar = $"WholeScreen/ChargeBar/4thPellet/Pellet"
@onready var ChargePellet5: TextureProgressBar = $"WholeScreen/ChargeBar/5thPellet/Pellet"
@onready var ChargePellet6: TextureProgressBar = $"WholeScreen/ChargeBar/6thPellet/Pellet"

@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer

var _current_pellet: TextureProgressBar
var _current_charge_value: float

func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_player.connect("health_changed", set_health_bar_energy)
	_player.connect("die", _screen_whiteout)
	set_health_bar_container()
	set_charge_bar()


func change_pellet():
	match _player.charge_level:
		0:
			_current_pellet = ChargePellet1
		1:
			_current_pellet = ChargePellet2
		2:
			_current_pellet = ChargePellet3
		3:
			_current_pellet = ChargePellet4
		4:
			_current_pellet = ChargePellet5
		5:
			_current_pellet = ChargePellet6
		6:
			pass

func decrease_pellet():
	_current_charge_value = _current_pellet.value
	_current_pellet.value = 0
	change_pellet()

func set_health_bar_container() -> void:
	health_bar_container.frame = Global.get_heart_tank_number()

func set_health_bar_energy(value: int) -> void:
	if value > 16:
		first_health_bar.value = 16
		second_health_bar.value = value - 16
	else:
		first_health_bar.value = value
		second_health_bar.value = 0

func _screen_whiteout() -> void:
	AnimPlayer.play("Whiteout")
	Engine.time_scale = 0.5
	await AnimPlayer.animation_finished
	Engine.time_scale = 1
	Global.reset_stage()

func set_charge_bar() -> void:
	match Global.get_charge_capacitor_number():
		0:
			_current_pellet = ChargePellet2
			$"WholeScreen/ChargeBar/1stPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/2ndPellet/Pellet".value = 16
		1:
			_current_pellet = ChargePellet3
			$"WholeScreen/ChargeBar/1stPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/2ndPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet".visible = true
			$"WholeScreen/ChargeBar/2ndPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/2ndPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/3rdPellet/Backing".frame = 1
			$"WholeScreen/ChargeBar/3rdPellet/Front".frame = 2
		2:
			_current_pellet = ChargePellet4
			$"WholeScreen/ChargeBar/1stPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/2ndPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/4thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet".visible = true
			$"WholeScreen/ChargeBar/4thPellet".visible = true
			$"WholeScreen/ChargeBar/2ndPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/2ndPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/3rdPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/3rdPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/4thPellet/Backing".frame = 1
			$"WholeScreen/ChargeBar/4thPellet/Front".frame = 2
		3:
			_current_pellet = ChargePellet5
			$"WholeScreen/ChargeBar/1stPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/2ndPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/4thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/5thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet".visible = true
			$"WholeScreen/ChargeBar/4thPellet".visible = true
			$"WholeScreen/ChargeBar/5thPellet".visible = true
			$"WholeScreen/ChargeBar/2ndPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/2ndPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/3rdPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/3rdPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/4thPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/4thPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/5thPellet/Backing".frame = 1
			$"WholeScreen/ChargeBar/5thPellet/Front".frame = 2
		4:
			_current_pellet = ChargePellet6
			$"WholeScreen/ChargeBar/1stPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/2ndPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/4thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/5thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/6thPellet/Pellet".value = 16
			$"WholeScreen/ChargeBar/3rdPellet".visible = true
			$"WholeScreen/ChargeBar/4thPellet".visible = true
			$"WholeScreen/ChargeBar/5thPellet".visible = true
			$"WholeScreen/ChargeBar/6thPellet".visible = true
			$"WholeScreen/ChargeBar/2ndPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/2ndPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/3rdPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/3rdPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/4thPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/4thPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/5thPellet/Backing".frame = 0
			$"WholeScreen/ChargeBar/5thPellet/Front".frame = 1
			$"WholeScreen/ChargeBar/6thPellet/Backing".frame = 1
			$"WholeScreen/ChargeBar/6thPellet/Front".frame = 2
