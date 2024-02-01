extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var PlayerInput : bool = false

const GhostResource = preload("res://Scenes/ghost_fade.tscn")
var ghostCounter : int = 0
@onready var DashTimer = $DashTimer

const BasicShotResource = preload("res://Scenes/Shot.tscn")
const ShotEffectResource = preload("res://Scenes/shot_effect.tscn")
@onready var BusterPosition = $BusterPosition
@onready var ShotTimer = $ShotTimer
var ChargeCounter : int = 0
var ChargeLevel : int = 0
var MaxChargeLevel : int = 0

enum STATE {ENTRANCE, EXIT, IDLE, RUN, JUMP, DASH, AIRDASH, JUMPDASH, SHOT, CHARGESHOT, RUNSHOT, JUMPSHOT, JUMPDASHSHOT, DASHSHOT, AIRDASHSHOT, DAMAGE, SLIDE}

var CurrentState = STATE.ENTRANCE

var FacingRight : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var PlayerSprite = $AnimatedSprite2D
@onready var CurrentPlayerSprite = PlayerSprite.sprite_frames
@onready var DebugStateLabel = $CurrentStateDebug


func _ready():
	PlayerSprite.play("entrance")
	DashTimer.stop()

func _physics_process(delta):
	
	HandleState()
	
	# Set gravity and speed depending on state
	if !is_on_floor() && !is_on_wall() && CurrentState != STATE.AIRDASH:
		velocity.y += gravity * delta
	if(is_on_wall_only()):
		velocity.y += (gravity/4) * delta
	if(CurrentState == STATE.JUMPDASH || CurrentState == STATE.JUMPDASHSHOT):
		SPEED = 500
	else:
		SPEED = 300
	
	# Check if the player is idling
	if (velocity == Vector2.ZERO && PlayerInput == true && is_on_floor() && ShotTimer.is_stopped()):
		CurrentState = STATE.IDLE

	# Check if the player is allowed to move the character
	if(PlayerInput == true):
		
		# Handle Shooting
		if(Input.is_action_just_pressed("Shot")):
			if(get_tree().get_nodes_in_group("PlayerProjectiles").size() >= 3):
				pass
			else:
				BasicShot()
		
		# Handle jumping
		if Input.is_action_just_pressed("Jump") && is_on_floor():
			# Check if dashing and if so, switch to a jumpdash
			if(Input.is_action_pressed("Dash")):
				CurrentState = STATE.JUMPDASH
				velocity.y = JUMP_VELOCITY
			else:
				CurrentState = STATE.JUMP
				velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("Left", "Right")
		if (direction != 0 && is_on_floor() && velocity.y >= 0 && CurrentState != STATE.DASH):
			CurrentState = STATE.RUN
		# Check which way the player is facing and flip sprites acccordingle
		if (direction > 0):
			FacingRight = true
			FlipPlayerSprite()
		elif (direction < 0):
			FacingRight = false
			FlipPlayerSprite()
		if (direction):
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Handle dashing
		if(Input.is_action_just_pressed("Dash")):
			DashTimer.start()
		if(Input.is_action_pressed("Dash") && !DashTimer.is_stopped()):
			if(CurrentState != STATE.JUMPDASH && is_on_floor()):
				CurrentState = STATE.DASH
			elif(CurrentState != STATE.JUMPDASH && !is_on_floor()):
				velocity.y = 0
				CurrentState = STATE.AIRDASH
			if(CurrentState == STATE.AIRDASH || CurrentState == STATE.DASH && FacingRight):
				velocity.x = 2 * SPEED
			elif(CurrentState == STATE.AIRDASH || CurrentState == STATE.DASH):
				velocity.x = -2 * SPEED
		if(Input.is_action_just_released("Dash") || DashTimer.is_stopped() && CurrentState == STATE.AIRDASH):
			CurrentState = STATE.JUMPDASH
		if(Input.is_action_just_released("Dash") || DashTimer.is_stopped() && CurrentState == STATE.DASH):
			CurrentState = STATE.IDLE
	
	move_and_slide()

func HandleState():
	match CurrentState:
		STATE.ENTRANCE:
			PlayerInput = false
			if(PlayerSprite.is_playing() == false):
				CurrentState = STATE.IDLE
				PlayerInput = true
		STATE.IDLE:
			PlayerSprite.play("idle")
			DebugStateLabel.set_text("IDLE")
		STATE.JUMP:
			PlayerSprite.play("jump")
			DebugStateLabel.set_text("JUMP")
		STATE.JUMPDASH:
			PlayerSprite.play("jump")
			GhostEffect()
			DebugStateLabel.set_text("JUMPDASH")
		STATE.RUN:
			PlayerSprite.play("run")
			DebugStateLabel.set_text("RUN")
		STATE.DASH:
			PlayerSprite.play("dash")
			GhostEffect()
			DebugStateLabel.set_text("DASH")
		STATE.AIRDASH:
			PlayerSprite.play("dash")
			GhostEffect()
			DebugStateLabel.set_text("AIRDASH")
		STATE.SHOT:
			PlayerSprite.play("run")
			DebugStateLabel.set_text("SHOT")
		STATE.CHARGESHOT:
			PlayerSprite.play("run")
			DebugStateLabel.set_text("CHARGESHOT")

func BasicShot():
	var BasicShotInstance = BasicShotResource.instantiate()
	var ShotEffectInstance = ShotEffectResource.instantiate()
	if(FacingRight):
		BasicShotInstance.getDirection(Vector2(1, 0))
		if(BusterPosition.position.x < 0):
			FlipBusterPosition()
	else:
		BasicShotInstance.getDirection(Vector2(-1, 0))
		ShotEffectInstance.flip_h = true
		BasicShotInstance.flip(true)
		if(BusterPosition.position.x > 0):
			FlipBusterPosition()
	get_parent().add_child(BasicShotInstance)
	add_child(ShotEffectInstance)
	BasicShotInstance.position = BusterPosition.global_position
	ShotEffectInstance.position = BusterPosition.position

func HandleCharging():
	if(ChargeLevel == MaxChargeLevel):
		pass
	else:
		ChargeCounter += 1
		if(ChargeCounter > 40):
			ChargeLevel += 1
			ChargeCounter = 0

func FlipBusterPosition():
	BusterPosition.position.x = BusterPosition.position.x * -1

func FlipPlayerSprite():
	if (FacingRight):
		PlayerSprite.flip_h = true
	else:
		PlayerSprite.flip_h = false

func GhostEffect():
	ghostCounter += 1
	if(ghostCounter > 2):
		var GhostInstance = GhostResource.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture(CurrentPlayerSprite.get_frame_texture(PlayerSprite.animation, PlayerSprite.frame))
		GhostInstance.flip_h = PlayerSprite.flip_h
		GhostInstance.flip_v = PlayerSprite.flip_v
		GhostInstance.position = global_position
		ghostCounter = 0

