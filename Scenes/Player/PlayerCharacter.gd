extends CharacterBody2D

const RIGHT: int = 1
const LEFT: int = -1

var speed := 300.0
const JUMP_VELOCITY := -400.0
var player_input := false
var spent_dash := false
var facing_direction: int = -1
var _is_shooting := false
var is_dashing := false

var _charge_counter: int = 0
var charge_level: int = 0
var _max_charge_level: int = 2

var _max_health: int = 16
var health: int = 16

@onready var SFXPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var PlyrStateMachine: PlayerStateMachine = $PlayerStateMachine
@onready var UIControl: Hud = get_tree().get_first_node_in_group("UI Elements")

const GhostResource: Resource = preload("res://Scenes/Effects/ghost_fade.tscn")
var ghostCounter: int = 0

const ShotSFX: Resource = preload("res://Sound/BusterShot.wav")
const ChargeShotSFX: Resource = preload("res://Sound/BusterChargeShot.wav")
const JumpSFX: Resource = preload("res://Sound/XJump.wav")
const DashSFX: Resource = preload("res://Sound/XDash.wav")
const DamagedSFX: Resource = preload("res://Sound/XHit.wav")
const DeathSFX: Resource = preload("res://Sound/XDeath.wav")
const TankGetSFX: Resource = preload("res://Sound/Heart Powerup.wav")

@onready var InvulnerabilityTimer: Timer = $InvulnTimer
@onready var CoyoteTimer: Timer = $CoyoteTimer
@onready var RightRayCast: RayCast2D = $RightRCast
@onready var LeftRayCast: RayCast2D = $LeftRCast
@onready var DeathParticles: GPUParticles2D = $"Death Particles"

const DustResource = preload("res://Scenes/Effects/dust_particle.tscn")
@onready var DustPosition: Marker2D = $DustPosition
var DustCounter: int = 0

const BombResource: Resource = preload("res://Scenes/Effects/small_bombs.tscn")
const UpperResource: Resource = preload("res://Scenes/Effects/ether_fire.tscn")
const BarrageResource: Resource = preload("res://Scenes/Effects/chasers.tscn")

const BasicShotResource: Resource = preload("res://Scenes/Effects/shot.tscn")
const ShotEffectResource: Resource = preload("res://Scenes/Effects/shot_effect.tscn")
const ChargeShotResource: Resource = preload("res://Scenes/Effects/plasma_shot.tscn")

@onready var BusterPosition: Marker2D = $BusterPosition
@onready var ShotTimer: Timer = $ShotTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var CurrentPlayerSprite: Sprite2D
@onready var PlayerAnimations: AnimationPlayer = $AnimationPlayer
@onready var DebugStateLabel: Label = $CurrentStateDebug


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if(player_input == false):
		return
	
	#Basic attack
	if(event.is_action_pressed("Shot")):
		#If more than 3 shots exist or one of the triggers is held, ignore shot button presses
			if (get_tree().get_nodes_in_group("PlayerProjectiles").size() >= 3):
				pass
			elif Input.is_action_pressed("Defensive Trigger") || Input.is_action_pressed("Offensive Trigger"):
				pass
			else:
				basicShot()
	

func _physics_process(_delta: float) -> void:
	handleCharging()

func changePlayerControl(boolean: bool) -> void:
	player_input = boolean

func basicShot() -> void:
	SFXPlayer.set_stream(ShotSFX)
	SFXPlayer.play()
	_is_shooting = true
	ShotTimer.start(0.3)
	var BasicShotInstance: Shot = BasicShotResource.instantiate()
	var ShotEffectInstance: ShotEffect = ShotEffectResource.instantiate()
	BasicShotInstance.getDirection(Vector2(facing_direction, 0))
	if(facing_direction == LEFT):
		ShotEffectInstance.flip_h = true
		BasicShotInstance.flip(true)
	get_parent().add_child(BasicShotInstance)
	add_child(ShotEffectInstance)
	BasicShotInstance.position = BusterPosition.global_position
	ShotEffectInstance.position = BusterPosition.position

func plasmaShot() -> void:
	removecharge_level()
	SFXPlayer.set_stream(ChargeShotSFX)
	SFXPlayer.play()
	var PlasmaShotInstance: PlasmaShot = ChargeShotResource.instantiate()
	PlasmaShotInstance.getDirection(Vector2(facing_direction, 0))
	if(facing_direction == LEFT):
		PlasmaShotInstance.flip(true)
	get_parent().add_child(PlasmaShotInstance)
	PlasmaShotInstance.position = BusterPosition.global_position

func disengage() -> void:
	removecharge_level()
	var BombInstanceHigh: SmallBombs = BombResource.instantiate()
	var BombInstanceMid: SmallBombs = BombResource.instantiate()
	var BombInstanceLow: SmallBombs = BombResource.instantiate()
	BombInstanceHigh.getDirection(facing_direction)
	BombInstanceMid.getDirection(facing_direction)
	BombInstanceLow.getDirection(facing_direction)
	get_parent().add_child(BombInstanceHigh)
	get_parent().add_child(BombInstanceMid)
	get_parent().add_child(BombInstanceLow)
	BombInstanceHigh.position = BusterPosition.global_position
	BombInstanceHigh.position.y -= 15
	BombInstanceHigh.velocity.x += facing_direction * 50
	BombInstanceHigh.velocity.y += -90
	BombInstanceMid.position = BusterPosition.global_position
	BombInstanceMid.velocity.x += facing_direction * 20
	BombInstanceMid.velocity.y += -40
	BombInstanceLow.position = BusterPosition.global_position
	BombInstanceLow.position.x += facing_direction * -10
	BombInstanceLow.position.y += 15

func upper(time: float) -> void:
	removecharge_level()
	var UpperInstance: EtherFire = UpperResource.instantiate()
	UpperInstance.time = time
	add_child(UpperInstance)
	UpperInstance.position = BusterPosition.position
	if facing_direction == LEFT:
		UpperInstance.position.x += 11
	else:
		UpperInstance.position.x -= 11
	UpperInstance.position.y -= 21

func barrage() -> void:
	removecharge_level()
	var ChaserInstance1: Chasers = BarrageResource.instantiate()
	var ChaserInstance2: Chasers = BarrageResource.instantiate()
	var ChaserInstance3: Chasers = BarrageResource.instantiate()
	var ChaserInstance4: Chasers = BarrageResource.instantiate()
	ChaserInstance1.getDirection(Vector2(facing_direction * 2, -1))
	ChaserInstance2.getDirection(Vector2(facing_direction, -1))
	ChaserInstance3.getDirection(Vector2(facing_direction * -2, -1))
	ChaserInstance4.getDirection(Vector2(facing_direction * -1, -1))
	get_parent().add_child(ChaserInstance1)
	get_parent().add_child(ChaserInstance2)
	get_parent().add_child(ChaserInstance3)
	get_parent().add_child(ChaserInstance4)
	ChaserInstance1.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance2.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance3.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance4.position = BusterPosition.global_position - Vector2(0, 10)

func dive() -> void:
	pass

func handleCharging() -> void:
	if(charge_level == _max_charge_level):
		pass
	else:
		_charge_counter += 1
		UIControl.CurrentPellet.value = _charge_counter
		if(_charge_counter > 200):
			charge_level += 1
			UIControl.changePellet()
			_charge_counter = 0

func removecharge_level() -> void:
	charge_level -= 1
	UIControl.decreasePellet()
	UIControl.CurrentPellet.value = _charge_counter

func takeDamage(damage: int) -> void:
	if InvulnerabilityTimer.is_stopped():
		health -= damage
		UIControl.HealthBar.value = health
		if health <= 0:
			DeathParticles.emitting = true
			SFXPlayer.set_stream(DeathSFX)
			SFXPlayer.play()
			PlyrStateMachine._die()
		else:
			PlyrStateMachine._takeDamage()

func restoreHealth(value: int) -> void:
	if health + value <= _max_health:
		health += value
	else:
		health = _max_health
	UIControl.HealthBar.value = health

func upgradeHealth() -> void:
	if _max_health != 32:
		Global.MusicPlayer.volume_db -= 15 
		get_tree().paused = true
		SFXPlayer.set_stream(TankGetSFX)
		SFXPlayer.play()
		await get_tree().create_timer(0.6).timeout
		get_tree().paused = false
		Global.MusicPlayer.volume_db = Global.music_volume
		UIControl.upgradeHealth()
		_max_health += 2
		restoreHealth(2)
	else:
		pass

func upgradeEnergy() -> void:
	if _max_charge_level != 6:
		UIControl.upgradeEnergy()
		_max_charge_level += 1
	else:
		pass

func setDashProperties() -> void:
	is_dashing = true
	if(!is_on_floor()):
		spent_dash = true

func resetDashProperties() -> void:
	is_dashing = false
	spent_dash = false

func change_facing_direction(direction: int) -> void:
	if(facing_direction == direction):
		pass
	else:
		facing_direction = direction
		flipPlayerSprite()
		flipPositionMarkers()

func flipPositionMarkers() -> void:
	BusterPosition.position.x = BusterPosition.position.x * -1
	DustPosition.position.x = DustPosition.position.x * -1

func flipPlayerSprite() -> void:
	$DashSprite.flip_h = !$DashSprite.flip_h
	$IdleJumpRunSprite.flip_h = !$IdleJumpRunSprite.flip_h
	$EntranceExitSprite.flip_h = !$EntranceExitSprite.flip_h
	$ShootSprite.flip_h = !$ShootSprite.flip_h
	$DamageSprite.flip_h = !$DamageSprite.flip_h
	$WallClingSprite.flip_h = !$WallClingSprite.flip_h
	$UpperSprite.flip_h = !$UpperSprite.flip_h

func setCurrentSprite(path: NodePath) -> void:
	CurrentPlayerSprite = get_node(path)

func ghostEffect() -> void:
	ghostCounter += 1
	if(ghostCounter > 2):
		var GhostInstance: GhostFade = GhostResource.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture(CurrentPlayerSprite.texture)
		GhostInstance.hframes = CurrentPlayerSprite.hframes
		GhostInstance.vframes = CurrentPlayerSprite.vframes
		GhostInstance.frame = CurrentPlayerSprite.frame
		GhostInstance.flip_h = CurrentPlayerSprite.flip_h
		GhostInstance.position = global_position
		ghostCounter = 0

func createDust() -> void:
	DustCounter += 1
	if(DustCounter > 4):
		var DustInstance: DustParticle = DustResource.instantiate()
		get_parent().add_child(DustInstance)
		DustInstance.position = DustPosition.global_position
		DustCounter = 0

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
