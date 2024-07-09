class_name PlayerCharacter
extends CharacterBody2D


const RIGHT: int = 1
const LEFT: int = -1

var speed := 300.0
const JUMP_VELOCITY := -400.0
var player_input := false
var spent_dash := false
var facing_direction: int = 1
var _is_shooting := false
var is_dashing := false

var _charge_counter: int = 0
var charge_level: int = 0
var _max_charge_level: int = 2

var _max_health: int = 16
var health: int = 16

@onready var effect_audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var _player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var _hud: Hud = get_tree().get_first_node_in_group("UI Elements")

const GHOST_FADE_SCENE: PackedScene = preload("res://Scenes/Effects/ghost_fade.tscn")
var _ghost_counter: int = 0

const SHOT_AUDIO: AudioStream = preload("res://Sound/BusterShot.wav")
const CHARGE_SHOT_AUDIO: AudioStream = preload("res://Sound/BusterChargeShot.wav")
const JUMP_AUDIO: AudioStream = preload("res://Sound/XJump.wav")
const DASH_AUDIO: AudioStream = preload("res://Sound/XDash.wav")
const DAMAGED_AUDIO: AudioStream = preload("res://Sound/XHit.wav")
const DEATH_AUDIO: AudioStream = preload("res://Sound/XDeath.wav")
const PICKUP_TANK_AUDIO: AudioStream = preload("res://Sound/Heart Powerup.wav")

@onready var invincibility_timer: Timer = $InvulnTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var right_ray_cast: RayCast2D = $RightRCast
@onready var left_ray_cast: RayCast2D = $LeftRCast
@onready var _death_particles: GPUParticles2D = $"Death Particles"

const DUST_SCENE: PackedScene = preload("res://Scenes/Effects/dust_particle.tscn")
@onready var _dust_position: Marker2D = $DustPosition
var _dust_counter: int = 0

const _BOMB_SCENE: PackedScene = preload("res://Scenes/Effects/small_bombs.tscn")
const _UPPER_SCENE: PackedScene = preload("res://Scenes/Effects/ether_fire.tscn")
const _BARRAGE_SCENE: PackedScene = preload("res://Scenes/Effects/chasers.tscn")
const _PARRY_SCENE: PackedScene = preload("res://Scenes/Effects/parry_burst.tscn")
const _FLASH_SCENE: PackedScene = preload("res://Scenes/Effects/flash_burst.tscn")
const _ORBITAL_BIT_SCENE: PackedScene = preload("res://Scenes/Effects/orbital_bit.tscn")

const _SHOT_SCENE: PackedScene = preload("res://Scenes/Effects/shot.tscn")
const _SHOT_EFFECT_SCENE: PackedScene = preload("res://Scenes/Effects/shot_effect.tscn")
const _CHARGE_SHOT_SCENE: PackedScene = preload("res://Scenes/Effects/plasma_shot.tscn")

@onready var _buster_position: Marker2D = $BusterPosition
@onready var _shot_timer: Timer = $ShotTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player_animations: AnimationPlayer = $AnimationPlayer
@onready var debug_state_label: Label = $CurrentStateDebug


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if player_input == false:
		return
	
	#Basic attack
	if event.is_action_pressed("Shot"):
		#If more than 3 shots exist or one of the triggers is held, ignore shot button presses
			if get_tree().get_nodes_in_group("PlayerProjectiles").size() >= 3:
				pass
			elif Input.is_action_pressed("Defensive Trigger") || Input.is_action_pressed("Offensive Trigger"):
				pass
			else:
				_basic_shot()


func _physics_process(_delta: float) -> void:
	_handle_charging()


func change_player_control(boolean: bool) -> void:
	player_input = boolean


func _basic_shot() -> void:
	effect_audio_player.set_stream(SHOT_AUDIO)
	effect_audio_player.play()
	_is_shooting = true
	_shot_timer.start(0.3)
	var shot: Shot = _SHOT_SCENE.instantiate()
	var shot_effect: ShotEffect = _SHOT_EFFECT_SCENE.instantiate()
	shot.getDirection(Vector2(facing_direction, 0))
	if facing_direction == LEFT:
		shot_effect.flip_h = true
		shot.flip(true)
	get_parent().add_child(shot)
	add_child(shot_effect)
	shot.position = _buster_position.global_position
	shot_effect.position = _buster_position.position



#Offensive specials
func plasma_shot() -> void:
	_remove_charge_level()
	effect_audio_player.set_stream(CHARGE_SHOT_AUDIO)
	effect_audio_player.play()
	var instance: PlasmaShot = _CHARGE_SHOT_SCENE.instantiate()
	instance.getDirection(Vector2(facing_direction, 0))
	if facing_direction == LEFT:
		instance.flip(true)
	get_parent().add_child(instance)
	instance.position = _buster_position.global_position

func upper(time: float) -> void:
	_remove_charge_level()
	var instance: EtherFire = _UPPER_SCENE.instantiate()
	instance.time = time
	add_child(instance)
	instance.position = _buster_position.position
	instance.position.x = facing_direction * -11
	instance.position.y -= 21

func barrage() -> void:
	_remove_charge_level()
	var x: Array[int] = [2, 1, -2, -1]
	for i in 4:
		var chaser: Chasers = _BARRAGE_SCENE.instantiate()
		chaser.getDirection(Vector2(facing_direction * x[i], -1))
		get_parent().add_child(chaser)
		chaser.position = _buster_position.global_position - Vector2(0, 10)

func dive() -> void:
	_remove_charge_level()

func punch() -> void:
	_remove_charge_level()

func blade() -> void:
	_remove_charge_level()

func breaker() -> void:
	_remove_charge_level()

func whirlwind() -> void:
	_remove_charge_level()


#Defensive specials
func disengage() -> void:
	_remove_charge_level()
	var y: Array[int] = [15, 0, 15]
	var x: Array[int] = [0, 0, -10]
	var vy: Array[int] = [-90, -40, 15]
	var vx: Array[int] = [50, 20, -10]
	for i in 3:
		var bomb: SmallBombs = _BOMB_SCENE.instantiate()
		bomb.getDirection(facing_direction)
		get_parent().add_child(bomb)
		bomb.position = _buster_position.global_position
		bomb.position.x += facing_direction * x[i]
		bomb.position.y -= y[i]
		bomb.velocity.x += facing_direction * vx[i]
		bomb.velocity.y += vy[i]

func parry() -> void:
	_remove_charge_level()
	var instance: ParryBurst = _PARRY_SCENE.instantiate()
	add_child(instance)
	instance.position = _buster_position.position

func flash() -> void:
	_remove_charge_level()
	var instance: FlashBurst = _FLASH_SCENE.instantiate()
	add_child(instance)

func blink() -> void:
	_remove_charge_level()

func orbital_bit() -> void:
	_remove_charge_level()
	var instance: OrbitalBit = _ORBITAL_BIT_SCENE.instantiate()
	add_child(instance)

func chain_grab() -> void:
	_remove_charge_level()

func mine_thrower() -> void:
	_remove_charge_level()

func recoil() -> void:
	_remove_charge_level()


func _handle_charging() -> void:
	if charge_level == _max_charge_level:
		pass
	else:
		_charge_counter += 1
		_hud.CurrentPellet.value = _charge_counter
		if(_charge_counter > 200):
			charge_level += 1
			_hud.changePellet()
			_charge_counter = 0


func _remove_charge_level() -> void:
	charge_level -= 1
	_hud.decreasePellet()
	_hud.CurrentPellet.value = _charge_counter


func takeDamage(damage: int) -> void:
	if invincibility_timer.is_stopped():
		health -= damage
		_hud.HealthBar.value = health
		if health <= 0:
			_death_particles.emitting = true
			effect_audio_player.set_stream(DEATH_AUDIO)
			effect_audio_player.play()
			_player_state_machine._die()
		else:
			_player_state_machine._takeDamage()


func restore_health(value: int) -> void:
	if health + value <= _max_health:
		health += value
	else:
		health = _max_health
	_hud.HealthBar.value = health


func upgrade_health() -> void:
	if _max_health != 32:
		Global.MusicPlayer.volume_db -= 15 
		get_tree().paused = true
		effect_audio_player.set_stream(PICKUP_TANK_AUDIO)
		effect_audio_player.play()
		await get_tree().create_timer(0.6).timeout
		get_tree().paused = false
		Global.MusicPlayer.volume_db = Global.music_volume
		_hud.upgrade_health()
		_max_health += 2
		restore_health(2)
	else:
		pass


func upgrade_energy() -> void:
	if _max_charge_level != 6:
		_hud.upgrade_energy()
		_max_charge_level += 1
	else:
		pass


func set_dash_properties() -> void:
	is_dashing = true
	if(!is_on_floor()):
		spent_dash = true


func reset_dash_properties() -> void:
	is_dashing = false
	spent_dash = false


func change_facing_direction(direction: int) -> void:
	if facing_direction == direction:
		pass
	else:
		facing_direction = direction
		_flip_player_sprite()
		_flip_position_markers()


func _flip_position_markers() -> void:
	_buster_position.position.x = _buster_position.position.x * -1
	_dust_position.position.x = _dust_position.position.x * -1


func _flip_player_sprite() -> void:
	$PlayerSprite.flip_h = !$PlayerSprite.flip_h



func ghostEffect() -> void:
	_ghost_counter += 1
	if _ghost_counter > 2:
		var GhostInstance: GhostFade = GHOST_FADE_SCENE.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture($PlayerSprite.texture)
		GhostInstance.hframes = $PlayerSprite.hframes
		GhostInstance.vframes = $PlayerSprite.vframes
		GhostInstance.frame = $PlayerSprite.frame
		GhostInstance.flip_h = $PlayerSprite.flip_h
		GhostInstance.position = global_position
		_ghost_counter = 0


func create_dust() -> void:
	_dust_counter += 1
	if _dust_counter > 4:
		var DustInstance: DustParticle = DUST_SCENE.instantiate()
		get_parent().add_child(DustInstance)
		DustInstance.position = _dust_position.global_position
		_dust_counter = 0


func _on_shot_timer_timeout() -> void:
	_is_shooting = false


func handle_horizontal() -> void:
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if velocity.x > 0:
		change_facing_direction(RIGHT)
	elif velocity.x < 0:
		change_facing_direction(LEFT)
	
	velocity.x = speed * input_direction_x


func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("Hazards"):
		takeDamage(32)


func _on_hit_box_body_entered(body: Node) -> void:
	if(body.has_method("takeDamage")):
		body.takeDamage(15)
