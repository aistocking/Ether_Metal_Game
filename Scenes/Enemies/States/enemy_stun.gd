extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _stun_timer: Timer = $StunTimer
@onready var _stun_instance: Node2D

signal stun_recover

func enter(_msg := {}) -> void:
	_enemy = owner
	_enemy.anim_player.play("RESET")
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO
	if _msg.has("parried"):
		_enemy.velocity.x = 100 * (_enemy.facing_direction * -1)
	_stun_timer.start(5.0)
	_enemy.sprite.frame = 0
	_enemy._create_stun_fx()
	_enemy.player_detection_shape.set_deferred("disabled", true)
	_enemy._physical_hit_box.set_deferred("disabled", true)
	Global._hit_stun_slowdown(0.3,0.15)

func handle_input(event):
	pass

func physics_update(delta: float) -> void:
	if !_enemy.is_on_floor():
		_enemy.velocity.y += (gravity * delta) * 0.2
	if _enemy.is_on_floor():
		if _enemy.velocity.x > 25 || _enemy.velocity.x < -25:
			_enemy.create_dust()
	_enemy.velocity.x = move_toward(_enemy.velocity.x, 0, 1)
	_enemy.move_and_slide()
	
func exit() -> void:
	_stun_timer.stop()


func _on_stun_timer_timeout():
	emit_signal("stun_recover")
	if _enemy.is_on_floor():
		state_machine.transition_to("EnemyIdle")
	else:
		state_machine.transition_to("EnemyRecover")
