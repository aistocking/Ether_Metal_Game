class_name HealthComponent
extends Node


@export var _health: int
@export var _max_health: int
@export var _stun_health: int
@export var _max_stun_health: int
@export var _hurt_box: HurtBox

signal die
signal stun_break (parried: bool)
signal health_change (health: int, stun_health: int)
signal push (direction: Vector2, power: int)
signal stun_health_change

# Called when the node enters the scene tree for the first time.
func _ready():
	_hurt_box.connect("damage_taken", _take_damage)
	get_parent().connect("parried", _parried)
	_health = _max_health
	_stun_health = _max_stun_health
	emit_signal("health_change", _health, _stun_health)
	$"../EnemyHitBox".connect("was_parried", _parried)
func _take_damage(health_damage: int, stun_damage: int, direction: Vector2, power: float) -> void:
	if _stun_health <= 0:
		health_damage *= 2
		stun_damage = 0
		emit_signal("push", direction, power)
	_health -= health_damage
	_stun_health -= stun_damage
	if health_damage > 0 or stun_damage > 0:
		emit_signal("health_change", _health, _stun_health)
		if _health <= 0:
			emit_signal("die")
		if _stun_health <= 0 && stun_damage != 0:
			if stun_damage == _max_stun_health:
				emit_signal("stun_break", true)
			else:
				emit_signal("stun_break", false)

func reset_stun_health() -> void:
	_stun_health = _max_stun_health
	
func _parried() -> void:
	_take_damage(0, _max_stun_health, Vector2(0,0), 0)
