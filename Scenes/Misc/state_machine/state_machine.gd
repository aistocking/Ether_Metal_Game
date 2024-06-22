class_name StateMachine
extends Node

signal transitioned(state_name: String)

@export var initial_state: State

@onready var _state := initial_state

func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		child.state_machine = self
	_state.enter()
	emit_signal("transitioned", _state.name)

func _unhandled_input(event: InputEvent) -> void:
	_state.handle_input(event)

func _process(delta: float) -> void:
	_state.update(delta)

func _physics_process(delta: float) -> void:
	_state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	
	if not has_node(target_state_name):
		return

	_state.exit()
	_state = get_node(target_state_name)
	_state.enter(msg)
	emit_signal("transitioned", _state.name)

func _takeDamage() -> void:
	_state.takeDamage()

func _die() -> void:
	_state.die()

