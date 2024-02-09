class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)
@onready var DebugStateLabel = $"../CurrentStateDebug"

func _ready() -> void:
	await owner.ready
	
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	
	DebugStateLabel.text = state.name
	
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
	DebugStateLabel.text = target_state_name
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
