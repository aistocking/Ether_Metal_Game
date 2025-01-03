extends Node2D


@onready var _group: Node2D = $MassGroup/Group1
@onready var _mass_group: Node2D = $MassGroup
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 19:
		var _new_instance  = $MassGroup/Group1/FirstCross.duplicate()
		_new_instance.position = Vector2(13, 12) * i
		_group.add_child(_new_instance)
	for i in range(1, 25):
		var _new_instance  = _group.duplicate()
		_new_instance.position.x = 26 * i
		for x in _new_instance.get_child_count():
			_new_instance.get_child(x).frame = (i*2) % 25
		_mass_group.add_child(_new_instance)
	
	$MassGroup/Group1/FirstCross.queue_free()



	
