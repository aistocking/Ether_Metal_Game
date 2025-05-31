class_name BasicEnemy
extends CharacterBody2D

const SHOVE_SPEED: float = 500
const RIGHT: int = 1
const LEFT: int = -1


var _health: int = 25
var _max_health: int = 25
var _stun_health: int = 10
var _max_stun_health: int = 10
var _damage: int = 3
const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")
const _hit_SFX: AudioStream = preload("res://Sound/BusterShotHit.wav")
const _wall_hit_sfx: AudioStream = preload("res://Sound/Intro_Stomp.wav")
const _big_hit_sfx: AudioStream = preload("res://Sound/Enemy Big Hit.wav")
const _stun_break_sound: AudioStream = preload("res://Sound/StunBreak.wav")
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction: int = LEFT

const _stun_fx: PackedScene = preload("res://Scenes/Effects/stun_stars.tscn")
var _stun_instance

var _player: PlayerCharacter
var _camera: Camera2D

@onready var _flash_timer: Timer = $FlashTimer
@onready var sprite = $Sprite
@onready var _hurt_box: HurtBox = $HurtBox
@onready var _health_component: HealthComponent = $HealthComponent
@onready var _state_label: Label = $Label
@onready var _effect_audio_player: EffectAudioPlayer = $EffectAudioPlayer
@onready var _projectile_spawn_marker: Marker2D = $ProjectileSpawnLocation
@onready var _stun_fx_spawn_marker: Marker2D = $StunStarsSpawnLocation
@onready var anim_player: AnimationPlayer = $Anims
@onready var player_detection_shape: CollisionShape2D = $PlayerDetection/Collision
@onready var _physical_hit_box: Area2D = $EnemyHitBox
@onready var _state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var _bouncy_collision: CollisionShape2D = $BounceBoxes/Collision
var _tween: Tween

#Projectiles
const _BIG_PROJECTILE_SCENE: PackedScene = preload("res://Scenes/Enemies/Projectiles/en_big_ball.tscn")


const ENEMY_DUST_SCENE: PackedScene = preload("res://Scenes/Effects/dust_particle.tscn")
const SHOVE_TRAILS_SCENE: PackedScene = preload("res://Scenes/Effects/shove_trails.tscn")
@onready var _dust_position: Marker2D = $DustSpawnLocation
var _dust_counter: int = 0
var _trail_counter: int = 0

signal died
signal wall_bounce
signal attack_finished

func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_camera = get_tree().get_first_node_in_group("Camera")
	_health_component.connect("health_change", _update_health)
	_health_component.connect("health_change", _hit_flash)
	_health_component.connect("push", _hit_push)
	_health_component.connect("die", die)
	_health_component.connect("stun_break", _stun_break)
	_health = _health_component._health
	_max_health = _health_component._max_health
	_stun_health = _health_component._stun_health
	_max_stun_health = _health_component._max_stun_health
	$EnemyStateMachine/EnemyStun.connect("stun_recover", _restore_stun)
	$AspectRatioContainer/StunHealth.max_value = _health_component._max_stun_health
	$AspectRatioContainer/StunHealth.value = _stun_health
	set_wall_bounce_collision("Off")
	sprite.material.set_shader_parameter("stun", false)
	_reset_sprite_flash()

func _physics_process(delta):
	pass

func _hit_flash(health: int, stun_health: int):
	if health == _health || stun_health == _stun_health:
		sprite.material.set_shader_parameter("active", true)
		_flash_timer.start(0.1)

func _hit_push(direction: Vector2, power: int) -> void:
	if _stun_health <= 0:
		if power == -1:
			_state_machine.transition_to("EnemyShove", {"direction": direction})
		var push_vector = direction * power
		velocity += push_vector

func _reset_sprite_flash() -> void:
	if sprite.material.get_shader_parameter("stun") == false:
		sprite.material.set_shader_parameter("active", false)
		sprite.material.set_shader_parameter("mix_factor", 1)

func _on_flash_timer_timeout():
	_reset_sprite_flash()

func _update_health(health: int, stun: int) -> void:
	#_hit_push(direction, power)
	_health = health
	_stun_health = stun
	$AspectRatioContainer/StunHealth.value = _stun_health
	if _stun_health <= 0:
		_effect_audio_player.play_sound(_big_hit_sfx)
	else:
		_effect_audio_player.play_sound(_hit_SFX)
	

func _stun_break(b: bool) -> void:
	if b == true:
		_state_machine.transition_to("EnemyStun",{"parried": true})
	else:
		_state_machine.transition_to("EnemyStun")
	_stun_break_fx_start()
	_set_stun_shader()

func _set_stun_shader() -> void:
	sprite.material.set_shader_parameter("active", true)
	sprite.material.set_shader_parameter("stun", true)
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_method(func(value): sprite.material.set_shader_parameter("mix_factor", value), 0.4, 0.8, 1)
	_tween.chain().tween_method(func(value): sprite.material.set_shader_parameter("mix_factor", value), 0.8, 0.4, 1)

func _create_stun_fx() -> void:
	_stun_instance = _stun_fx.instantiate()
	_stun_instance.position = _stun_fx_spawn_marker.position
	add_child(_stun_instance)

func _restore_stun() -> void:
	_health_component.reset_stun_health()
	_stun_instance.queue_free()
	_tween.kill()
	sprite.material.set_shader_parameter("stun", false)
	_reset_sprite_flash()

func flip() -> void:
	sprite.flip_h = !sprite.flip_h
	player_detection_shape.position.x = player_detection_shape.position.x * -1
	_physical_hit_box.position.x = _physical_hit_box.position.x * -1
	facing_direction = facing_direction * -1

func dash_attack() -> void:
	velocity.x = 550 * facing_direction
	_tween = create_tween()
	_tween.tween_property(self, "velocity:x", 0, 0.4)

func face_player() -> void:
	var comparison = global_position.x - _player.global_position.x
	if comparison < 0:
		if facing_direction == LEFT:
			flip()
	if comparison > 0:
		if facing_direction == RIGHT:
			flip()

func create_dust() -> void:
	_dust_counter += 1
	if _dust_counter > 4:
		var _instance: DustParticle = ENEMY_DUST_SCENE.instantiate()
		get_parent().add_child(_instance)
		_instance.global_position = _dust_position.global_position
		_dust_counter = 0

func create_shove_trails(left: bool) -> void:
	_trail_counter += 1
	if _trail_counter > 3:
		var _instance: ShoveTrails = SHOVE_TRAILS_SCENE.instantiate()
		if left == true:
			_instance.face_left()
		get_parent().add_child(_instance)
		_instance.global_position = global_position
		_trail_counter = 0

func set_wall_bounce_collision(text: String) -> void:
	match text:
		"Top":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.extents = Vector2(22,4)
			_bouncy_collision.position = Vector2(0,-21)
		"Bottom":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.extents = Vector2(22,4)
			_bouncy_collision.position = Vector2(0,21)
		"Right":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.extents = Vector2(4,15)
			_bouncy_collision.position = Vector2(15,0)
		"Left":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.extents = Vector2(4,15)
			_bouncy_collision.position = Vector2(-15,0)
		"Off":
			_bouncy_collision.set_deferred("disabled", true) 
			_bouncy_collision.shape.extents = Vector2(0,0)
			_bouncy_collision.position = Vector2(0,0)

func die():
	emit_signal("died")
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.global_position = global_position
	queue_free()


func _on_bounce_boxes_body_entered(body):
	if body == self:
		return
	emit_signal("wall_bounce")


func _on_bounce_boxes_area_entered(hurtbox: HurtBox):
	if hurtbox == $HurtBox:
		return
	if(hurtbox.has_method("take_damage")):
		hurtbox.take_damage(5, 35, Vector2(0,0), 0)
	emit_signal("wall_bounce")
		

func _stun_break_fx_start() -> void:
	$Sprite/Cracks.visible = true
	$Sprite/Cracks.play()

func _on_cracks_animation_finished():
	$SmallShards.visible = true
	$MediumShards.visible = true
	$ShineBurst.visible = true
	$Sprite/Cracks.visible = false
	$ShineBurst.play()
	_effect_audio_player.play_sound(_stun_break_sound)
	$SmallShards.emitting = true
	$MediumShards.emitting = true

func _on_medium_shards_finished():
	$SmallShards.visible = false
	$MediumShards.visible = false
	$ShineBurst.visible = false


func _on_player_detection_body_entered(body):
	_state_machine.transition_to("EnemyAttack")


func _on_anims_animation_finished(anim_name):
	if anim_name == "Attack1":
		_tween.kill()
		emit_signal("attack_finished")


func _on_enemy_hit_box_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(_damage)
