class_name TimedDealthComponent
extends Timer


@export var victim: NodePath = ".."
@onready var _victim = get_node(victim)


func _ready() -> void:
	connect("timeout", _on_timeout)


func _on_timeout() -> void:
	if _victim.has_method("die"):
		_victim.die()
	# TODO: should rename the '_die's to 'die' since they are public
	elif _victim.has_method("_die"):
		_victim._die()
	else:
		_victim.queue_free()
