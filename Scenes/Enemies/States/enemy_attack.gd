extends State

var _player: CharacterBody2D
var _enemy: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter(_msg := {}) -> void:
	_enemy = owner
	_player = get_tree().get_first_node_in_group("Player")
	_enemy.velocity = Vector2.ZERO
	_enemy._anim_player.play("Attack1")
	_enemy.connect("attack_finished", attack_finish)
	_enemy.player_detection_shape.set_deferred("disabled", true)
	_enemy._physical_hit_box.disable_collision(false)

func physics_update(delta: float) -> void:
	if _enemy.is_on_floor():
		if _enemy.velocity.x > 20 || _enemy.velocity.x < -20:
			_enemy.create_dust()
	_enemy.move_and_slide()

func attack_finish() -> void:
	_enemy.face_player()
	state_machine.transition_to("EnemyIdle")
	
func exit() -> void:
	_enemy._physical_hit_box.disable_collision(true)
