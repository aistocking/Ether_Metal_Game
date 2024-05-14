extends CharacterBody2D

const RIGHT : int = 1
const LEFT : int = -1

var SPEED : float = 300.0
var speed : float = 300.0
const JUMP_VELOCITY : float = -400.0
var PlayerInput : bool = false
var SpentDash : bool = false
var FacingDirection : int = -1
var IsShooting : bool = false
var IsDashing : bool = false

var ChargeCounter : int = 0
var ChargeLevel : int = 0
var MaxChargeLevel : int = 2

var MaxHealth : int = 16
var Health : int = 16

@onready var SFXPlayer = $AudioStreamPlayer

@onready var PlyrStateMachine = $PlayerStateMachine

@onready var UIControl = get_tree().get_first_node_in_group("UI Elements")

const GhostResource = preload("res://Scenes/Effects/ghost_fade.tscn")
var ghostCounter : int = 0

var ShotSFX = preload("res://Sound/BusterShot.wav")
var ChargeShotSFX = preload("res://Sound/BusterChargeShot.wav")
var JumpSFX = preload("res://Sound/XJump.wav")
var DashSFX = preload("res://Sound/XDash.wav")
var DamagedSFX = preload("res://Sound/XHit.wav")
var DeathSFX = preload("res://Sound/XDeath.wav")
var TankGetSFX = preload("res://Sound/Heart Powerup.wav")

@onready var InvulnerabilityTimer = $InvulnTimer

@onready var CoyoteTimer = $CoyoteTimer

@onready var RightRayCast = $RightRCast
@onready var LeftRayCast = $LeftRCast

@onready var DeathParticles = $"Death Particles"

const DustResource = preload("res://Scenes/Effects/dust_particle.tscn")
@onready var DustPosition = $DustPosition
var DustCounter: int = 0

const BombResource = preload("res://Scenes/Effects/small_bombs.tscn")

const UpperResource = preload("res://Scenes/Effects/ether_fire.tscn")

const BarrageResource = preload("res://Scenes/Effects/chasers.tscn")

const BasicShotResource = preload("res://Scenes/Effects/shot.tscn")
const ShotEffectResource = preload("res://Scenes/Effects/shot_effect.tscn")
const ChargeShotResource = preload("res://Scenes/Effects/plasma_shot.tscn")
@onready var BusterPosition = $BusterPosition
@onready var ShotTimer = $ShotTimer




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var CurrentPlayerSprite
@onready var PlayerAnimations = $AnimationPlayer
@onready var DebugStateLabel = $CurrentStateDebug


func _ready():
	pass

func _input(event):
	if(PlayerInput == false):
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
	

func _physics_process(_delta):
	
	handleCharging()

func changePlayerControl(boolean):
	PlayerInput = boolean

func basicShot():
	SFXPlayer.set_stream(ShotSFX)
	SFXPlayer.play()
	IsShooting = true
	ShotTimer.start(0.3)
	var BasicShotInstance = BasicShotResource.instantiate()
	var ShotEffectInstance = ShotEffectResource.instantiate()
	BasicShotInstance.getDirection(Vector2(FacingDirection, 0))
	if(FacingDirection == LEFT):
		ShotEffectInstance.flip_h = true
		BasicShotInstance.flip(true)
	get_parent().add_child(BasicShotInstance)
	add_child(ShotEffectInstance)
	BasicShotInstance.position = BusterPosition.global_position
	ShotEffectInstance.position = BusterPosition.position

func plasmaShot():
	removeChargeLevel()
	SFXPlayer.set_stream(ChargeShotSFX)
	SFXPlayer.play()
	var PlasmaShotInstance = ChargeShotResource.instantiate()
	PlasmaShotInstance.getDirection(Vector2(FacingDirection, 0))
	if(FacingDirection == LEFT):
		PlasmaShotInstance.flip(true)
	get_parent().add_child(PlasmaShotInstance)
	PlasmaShotInstance.position = BusterPosition.global_position

func disengage():
	removeChargeLevel()
	var BombInstanceHigh = BombResource.instantiate()
	var BombInstanceMid = BombResource.instantiate()
	var BombInstanceLow = BombResource.instantiate()
	BombInstanceHigh.getDirection(FacingDirection)
	BombInstanceMid.getDirection(FacingDirection)
	BombInstanceLow.getDirection(FacingDirection)
	get_parent().add_child(BombInstanceHigh)
	get_parent().add_child(BombInstanceMid)
	get_parent().add_child(BombInstanceLow)
	BombInstanceHigh.position = BusterPosition.global_position
	BombInstanceHigh.position.y -= 15
	BombInstanceHigh.velocity.x += FacingDirection * 50
	BombInstanceHigh.velocity.y += -90
	BombInstanceMid.position = BusterPosition.global_position
	BombInstanceMid.velocity.x += FacingDirection * 20
	BombInstanceMid.velocity.y += -40
	BombInstanceLow.position = BusterPosition.global_position
	BombInstanceLow.position.x += FacingDirection * -10
	BombInstanceLow.position.y += 15

func upper(time):
	removeChargeLevel()
	var UpperInstance = UpperResource.instantiate()
	UpperInstance.time = time
	add_child(UpperInstance)
	UpperInstance.position = BusterPosition.position
	if FacingDirection == LEFT:
		UpperInstance.position.x += 11
	else:
		UpperInstance.position.x -= 11
	UpperInstance.position.y -= 21

func barrage():
	removeChargeLevel()
	var ChaserInstance1 = BarrageResource.instantiate()
	var ChaserInstance2 = BarrageResource.instantiate()
	var ChaserInstance3 = BarrageResource.instantiate()
	var ChaserInstance4 = BarrageResource.instantiate()
	ChaserInstance1.getDirection(Vector2(FacingDirection * 2, -1))
	ChaserInstance2.getDirection(Vector2(FacingDirection, -1))
	ChaserInstance3.getDirection(Vector2(FacingDirection * -2, -1))
	ChaserInstance4.getDirection(Vector2(FacingDirection * -1, -1))
	get_parent().add_child(ChaserInstance1)
	get_parent().add_child(ChaserInstance2)
	get_parent().add_child(ChaserInstance3)
	get_parent().add_child(ChaserInstance4)
	ChaserInstance1.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance2.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance3.position = BusterPosition.global_position - Vector2(0, 10)
	ChaserInstance4.position = BusterPosition.global_position - Vector2(0, 10)

func dive():
	pass

func handleCharging():
	if(ChargeLevel == MaxChargeLevel):
		pass
	else:
		ChargeCounter += 1
		UIControl.CurrentPellet.value = ChargeCounter
		if(ChargeCounter > 200):
			ChargeLevel += 1
			UIControl.changePellet()
			ChargeCounter = 0

func removeChargeLevel():
	ChargeLevel -= 1
	UIControl.decreasePellet()
	UIControl.CurrentPellet.value = ChargeCounter

func takeDamage(damage : int):
	if InvulnerabilityTimer.is_stopped():
		Health -= damage
		UIControl.HealthBar.value = Health
		if Health <= 0:
			DeathParticles.emitting = true
			SFXPlayer.set_stream(DeathSFX)
			SFXPlayer.play()
			PlyrStateMachine._die()
		else:
			PlyrStateMachine._takeDamage()

func restoreHealth(value : int):
	if Health + value <= MaxHealth:
		Health += value
	else:
		Health = MaxHealth
	UIControl.HealthBar.value = Health

func upgradeHealth():
	if MaxHealth != 32:
		Global.MusicPlayer.volume_db -= 15 
		get_tree().paused = true
		SFXPlayer.set_stream(TankGetSFX)
		SFXPlayer.play()
		await get_tree().create_timer(0.6).timeout
		get_tree().paused = false
		Global.MusicPlayer.volume_db = Global.MusicVolume
		UIControl.upgradeHealth()
		MaxHealth += 2
		restoreHealth(2)
	else:
		pass

func upgradeEnergy():
	if MaxChargeLevel != 6:
		UIControl.upgradeEnergy()
		MaxChargeLevel += 1
	else:
		pass

func setDashProperties():
	IsDashing = true
	if(!is_on_floor()):
		SpentDash = true

func resetDashProperties():
	IsDashing = false
	SpentDash = false

func changeFacingDirection(direction : int):
	if(FacingDirection == direction):
		pass
	else:
		FacingDirection = direction
		flipPlayerSprite()
		flipPositionMarkers()

func flipPositionMarkers():
	BusterPosition.position.x = BusterPosition.position.x * -1
	DustPosition.position.x = DustPosition.position.x * -1

func flipPlayerSprite():
	$DashSprite.flip_h = !$DashSprite.flip_h
	$IdleJumpRunSprite.flip_h = !$IdleJumpRunSprite.flip_h
	$EntranceExitSprite.flip_h = !$EntranceExitSprite.flip_h
	$ShootSprite.flip_h = !$ShootSprite.flip_h
	$DamageSprite.flip_h = !$DamageSprite.flip_h
	$WallClingSprite.flip_h = !$WallClingSprite.flip_h
	$UpperSprite.flip_h = !$UpperSprite.flip_h

func setCurrentSprite(path):
	CurrentPlayerSprite = get_node(path)

func ghostEffect():
	ghostCounter += 1
	if(ghostCounter > 2):
		var GhostInstance = GhostResource.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture(CurrentPlayerSprite.texture)
		GhostInstance.hframes = CurrentPlayerSprite.hframes
		GhostInstance.vframes = CurrentPlayerSprite.vframes
		GhostInstance.frame = CurrentPlayerSprite.frame
		GhostInstance.flip_h = CurrentPlayerSprite.flip_h
		GhostInstance.position = global_position
		ghostCounter = 0

func createDust():
	DustCounter += 1
	if(DustCounter > 4):
		var DustInstance = DustResource.instantiate()
		get_parent().add_child(DustInstance)
		DustInstance.position = DustPosition.global_position
		DustCounter = 0

func _on_shot_timer_timeout():
	IsShooting = false

func handle_horizontal():
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if (velocity.x > 0):
		changeFacingDirection(RIGHT)
	elif (velocity.x < 0):
		changeFacingDirection(LEFT)
	
	velocity.x = speed * input_direction_x

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Hazards"):
		takeDamage(32)


func _on_hit_box_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(15)
