extends CanvasLayer

var Player

@onready var ChargeBar = $WholeScreen/ChargeBar
@onready var ChargeLevel = $WholeScreen/ChargeLevels
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ChargeBar.value = Player.ChargeCounter
	ChargeLevel.text = str(Player.ChargeLevel)
