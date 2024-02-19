extends CanvasLayer

var Player

@onready var ChargeBar = $WholeScreen/ChargeBar
@onready var ChargeLevel = $WholeScreen/ChargeLevels
@onready var HealthBar = $WholeScreen/HealthBar

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
	HealthBar.value = Player.Health


func _process(_delta):
	ChargeBar.value = Player.ChargeCounter
	ChargeLevel.text = str(Player.ChargeLevel)
	HealthBar.value = Player.Health
