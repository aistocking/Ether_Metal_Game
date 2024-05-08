class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()
@export var debugLabelPath := NodePath()

@onready var state: State = get_node(initial_state)
@onready var DebugStateLabel: = get_node(debugLabelPath)

func _ready() -> void:
	await owner.ready
	
	if DebugStateLabel != null:
		DebugStateLabel.setText(state.name)
	
	for child in get_children():
		child.state_machine = self
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
	if DebugStateLabel != null:
		DebugStateLabel.setText(state.name)

func _takeDamage() -> void:
	state.takeDamage()

func _die() -> void:
	state.die()

func _cutscene() -> void:
	state.cutscene()
