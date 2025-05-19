extends BasicEnemy


@onready var _shot_timer: Timer = $shot_timer
@onready var _sprites: AnimatedSprite2D = $Turret

var _angle_to_player

func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_sprites.speed_scale = 0.5

func _physics_process(delta):
	_angle_to_player = global_position.direction_to(_player.global_position).angle()
	_sprites.rotation = clamp(move_toward(_sprites.rotation, _angle_to_player, delta), -100, 100)
	_sprites.speed_scale = move_toward(_sprites.speed_scale, 5, delta)


func _on_shot_timer_timeout():
	_sprites.play("shot")
	$Turret/back_blast.play("default")
	var instance = _BIG_PROJECTILE_SCENE.instantiate()
	instance.global_position = $Turret/spawn_position.global_position
	instance.who_made_me(self)
	instance.set_direction(global_position.direction_to($Turret/bullet_traget.global_position))
	get_parent().add_child(instance)

func _on_turret_animation_finished():
	_sprites.play("default")
	_sprites.speed_scale = 0.5
