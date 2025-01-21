extends CharacterBody2D

const SHOVE_SPEED: float = 500
const RIGHT: int = 1
const LEFT: int = -1


var _health: int = 25
var _max_health: int = 25
var _stun_health: int = 10
var _max_stun_health: int = 10
var _damage: int = 1
const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")
var _hit_SFX: AudioStream = preload("res://Sound/BusterShotHit.wav")
var _wall_hit_sfx: AudioStream = preload("res://Sound/Intro_Stomp.wav")
var _big_hit_sfx: AudioStream = preload("res://Sound/Enemy Big Hit.wav")
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction = LEFT

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
@onready var _state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var right_ray_cast: RayCast2D = $RightRayCast
@onready var left_ray_cast: RayCast2D = $LeftRayCast
var _tween: Tween


const ENEMY_DUST_SCENE: PackedScene = preload("res://Scenes/Effects/dust_particle.tscn")
const SHOVE_TRAILS_SCENE: PackedScene = preload("res://Scenes/Effects/shove_trails.tscn")
@onready var _dust_position: Marker2D = $DustSpawnLocation
var _dust_counter: int = 0
var _trail_counter: int = 0

signal died

func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_camera = get_tree().get_first_node_in_group("Camera")
	_health_component.connect("health_change", _update_health)
	_health_component.connect("health_change", _hit_flash)
	_health_component.connect("push", _hit_push)
	_health_component.connect("die", die)
	_health_component.connect("stun_break", _stun_break)
	_health_component._health = _health
	_health_component._max_health = _max_health
	_health_component._stun_health = _stun_health
	_health_component._max_stun_health = _max_stun_health
	$EnemyStateMachine/EnemyStun.connect("stun_recover", _restore_stun)
	$AspectRatioContainer/Health.max_value = _health_component._max_health
	$AspectRatioContainer/StunHealth.max_value = _health_component._max_stun_health
	$AspectRatioContainer/Health.value = _health
	$AspectRatioContainer/StunHealth.value = _stun_health
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
	$AspectRatioContainer/Health.value = _health
	$AspectRatioContainer/StunHealth.value = _stun_health
	_effect_audio_player.play_sound(_hit_SFX)
	

func _stun_break() -> void:
	_state_machine.transition_to("EnemyStun")
	sprite.material.set_shader_parameter("active", true)
	sprite.material.set_shader_parameter("stun", true)
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
	_reset_sprite_flash()

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

func die():
	emit_signal("died")
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.global_position = global_position
	queue_free()
