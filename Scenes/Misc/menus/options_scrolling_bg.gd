extends Control


@onready var _group1: Node2D = $MiddleAnchor/Group1
@onready var _group2: Node2D = $MiddleAnchor/Group2

func _ready():
	pass # Replace with function body.


func _process(delta):
	_group1.position.y += 11 * delta
	_group2.position.y += 11 * delta
	if _group1.position.y > 250:
		_group1.position.y += -916
	if _group2.position.y > 250:
		_group2.position.y += -916
