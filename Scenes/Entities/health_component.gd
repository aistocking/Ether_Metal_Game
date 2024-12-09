class_name HealthComponent
extends Node


@export var _health: int
@export var _max_health: int
@export var _stun_health: int
@export var _max_stun_health: int
@export var _hurt_box: HurtBox

signal die
signal restore_stun (direction: Vector2, power: int)
signal stun_break
signal health_change (health: int, stun_health: int)
signal stun_health_change

# Called when the node enters the scene tree for the first time.
func _ready():
	_hurt_box.connect("damage_taken", _take_damage)
	_health = _max_health
	_stun_health = _max_stun_health
	emit_signal("health_change", _health, _stun_health)

func _reset_stun_health() -> void:
	_stun_health = _max_stun_health

func _take_damage(health_damage: int, stun_damage: int, direction: Vector2) -> void:
	if _stun_health <= 0:
		health_damage *= 2
		stun_damage = 0
		emit_signal("restore_stun", direction, health_damage)
		_reset_stun_health()
	_health -= health_damage
	_stun_health -= stun_damage
	if health_damage > 0 or stun_damage > 0:
		emit_signal("health_change", _health, _stun_health)
		if _health <= 0:
			emit_signal("die")
		if _stun_health <= 0:
			emit_signal("stun_break")
