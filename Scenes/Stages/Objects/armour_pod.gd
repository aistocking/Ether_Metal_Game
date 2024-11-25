extends Node2D

var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	Global.acquire_armor(Global.Armors.Arms)
	_player.set_armour_peices()
	queue_free()
