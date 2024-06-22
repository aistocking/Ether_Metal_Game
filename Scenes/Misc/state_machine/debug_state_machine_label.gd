@tool
class_name DebugStateMachineLabel
extends Label


@export var state_machine: StateMachine:
	set(_state_machine):
		if (state_machine != _state_machine):
			state_machine = _state_machine
			update_configuration_warnings()

var _heat := 1.0


func _ready() -> void:
	if not Engine.is_editor_hint():
		if state_machine != null:
			state_machine.transitioned.connect(_on_transitioned)


func _on_transitioned(state_name: String) -> void:
	_heat = max(0, _heat - 0.2)
	text = state_name


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		add_theme_color_override("font_color", Color(1, _heat, _heat))


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		_heat = min(1, _heat + 0.06)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	if state_machine == null:
		warnings.append("Please specify a StateMachine.")
	
	return warnings
