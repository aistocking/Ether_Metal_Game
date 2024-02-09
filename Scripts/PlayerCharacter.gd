extends CharacterBody2D

const RIGHT : int = 1
const LEFT : int = -1

var SPEED = 300.0
var speed = 300.0
const JUMP_VELOCITY = -400.0
var PlayerInput : bool = false
var SpentDash : bool = false
var FacingDirection : int = -1
var IsShooting : bool = false
var IsDashing : bool = false

const GhostResource = preload("res://Scenes/Effects/ghost_fade.tscn")
var ghostCounter : int = 0
@onready var DashTimer = $DashTimer

const BasicShotResource = preload("res://Scenes/Effects/shot.tscn")
const ShotEffectResource = preload("res://Scenes/Effects/shot_effect.tscn")
@onready var BusterPosition = $BusterPosition
@onready var ShotTimer = $ShotTimer

var ChargeCounter : int = 0
var ChargeLevel : int = 0
var MaxChargeLevel : int = 2

var Health : int = 16

enum STATE {ENTRANCE, EXIT, IDLE, RUN, JUMP, DASH, AIRDASH, JUMPDASH, SPECIAL, DAMAGE, SLIDE, DIE}
enum SPECIALS {DIVE, UPPER, PLASMA, BARRAGE, BLINK, FLASH, PARRY, DISENGAGE}

var CurrentState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var PlayerSprite = $AnimatedSprite2D
@onready var CurrentPlayerSprite = PlayerSprite.sprite_frames
@onready var DebugStateLabel = $CurrentStateDebug


func _ready():
	switchState(STATE.ENTRANCE)

func _input(event):
	if(PlayerInput == false):
		pass
	
	#Handle jumping
	if(event.is_action_pressed("Jump") && is_on_floor()):
		if(Input.is_action_pressed("Dash")):
			switchState(STATE.JUMPDASH)
			velocity.y = JUMP_VELOCITY
		else:
			switchState(STATE.JUMP)
			velocity.y = JUMP_VELOCITY
	
	#Handle dashing and its possible interactions with other buttons
	if(event.is_action_pressed("Dash")):
		if(is_on_floor()):
			switchState(STATE.DASH)
		elif(!SpentDash && !is_on_floor()):
			switchState(STATE.AIRDASH)
	if(event.is_action_released("Dash")):
		if(is_on_floor()):
			switchState(STATE.IDLE)
		elif(!is_on_wall()):
			switchState(STATE.JUMPDASH)
	
	#Basic attack
	if(event.is_action_pressed("Shot")):
		#If more than 3 shots exist, ignore shot button presses
			if(get_tree().get_nodes_in_group("PlayerProjectiles").size() >= 3):
				pass
			else:
				basicShot()
	
	#Offensive special attacks
	if(event.is_action_pressed("Shot") && event.is_action_pressed("Offensive Trigger")):
		pass
	#Defensive special attacks
	if(event.is_action_pressed("Shot") && event.is_action_pressed("Defensive Trigger")):
		pass
	
	# Check which way the player is facing and flip sprites acccordingly
	if(event.is_action_pressed("Left")):
		changeFacingDirection(LEFT)
	if(event.is_action_pressed("Right")):
		changeFacingDirection(RIGHT)
		
	# Check if the player is allowed to move the character
	if(PlayerInput == true):
		# Handle left and right movement
		var direction = Input.get_axis("Left", "Right")
		if (direction != 0 && is_on_floor() && velocity.y >= 0 && CurrentState != STATE.DASH):
			switchState(STATE.RUN)
		velocity.x = direction * SPEED

func _physics_process(delta):
	
	handleCharging()
	
	if(IsDashing == true):
		ghostEffect()
		if(CurrentState == STATE.DASH || CurrentState == STATE.AIRDASH):
			velocity.x = FacingDirection * 3 * SPEED
		else:
			velocity.x = FacingDirection * 2 * SPEED
	
	# Set gravity and speed depending on state
	if (!is_on_floor() && !is_on_wall() && CurrentState != STATE.AIRDASH):
		velocity.y += gravity * delta
	if(CurrentState == STATE.AIRDASH):
		velocity.y = 0
	if(is_on_wall_only()):
		velocity.y += (gravity/4) * delta
	if(CurrentState == STATE.JUMPDASH):
		SPEED = 500
	else:
		SPEED = 300
	
	# Check if the player is idling
	if (PlayerInput == true && is_on_floor() && ShotTimer.is_stopped() && !Input.is_anything_pressed()):
		switchState(STATE.IDLE)

	move_and_slide()

func switchState(state):
	if(CurrentState == state):
		pass
	match state:
		STATE.ENTRANCE:
			CurrentState = STATE.ENTRANCE
			PlayerInput = false
			PlayerSprite.play("entrance")
			DebugStateLabel.set_text("ENTRANCE")
		STATE.IDLE:
			CurrentState = STATE.IDLE
			resetDashProperties()
			PlayerSprite.play("idle")
			DebugStateLabel.set_text("IDLE")
		STATE.JUMP:
			CurrentState = STATE.JUMP
			resetDashProperties()
			PlayerSprite.play("jump")
			DebugStateLabel.set_text("JUMP")
		STATE.JUMPDASH:
			CurrentState = STATE.JUMPDASH
			setDashProperties()
			PlayerSprite.play("jump")
			DebugStateLabel.set_text("JUMPDASH")
		STATE.RUN:
			CurrentState = STATE.RUN
			resetDashProperties()
			PlayerSprite.play("run")
			DebugStateLabel.set_text("RUN")
		STATE.DASH:
			CurrentState = STATE.DASH
			setDashProperties()
			PlayerSprite.play("dash")
			DebugStateLabel.set_text("DASH")
		STATE.AIRDASH:
			CurrentState = STATE.AIRDASH
			setDashProperties()
			PlayerSprite.play("dash")
			DebugStateLabel.set_text("AIRDASH")
		STATE.DIE:
			pass


func basicShot():
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

func handleCharging():
	if(ChargeLevel == MaxChargeLevel):
		pass
	else:
		ChargeCounter += 1
		if(ChargeCounter > 200):
			ChargeLevel += 1
			ChargeCounter = 0
			
func takeDamage(damage):
	Health -= damage
	if(Health <= 0):
		CurrentState = STATE.DIE

func setDashProperties():
	IsDashing = true
	DashTimer.start(0.7)
	if(!is_on_floor()):
		SpentDash = true

func resetDashProperties():
	IsDashing = false
	SpentDash = false

func changeFacingDirection(direction):
	if(FacingDirection == direction):
		pass
	else:
		FacingDirection = direction
		flipPlayerSprite()
		flipBusterPosition()

func flipBusterPosition():
	BusterPosition.position.x = BusterPosition.position.x * -1

func flipPlayerSprite():
	PlayerSprite.flip_h = !PlayerSprite.flip_h

func ghostEffect():
	ghostCounter += 1
	if(ghostCounter > 2):
		var GhostInstance = GhostResource.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture(CurrentPlayerSprite.get_frame_texture(PlayerSprite.animation, PlayerSprite.frame))
		GhostInstance.flip_h = PlayerSprite.flip_h
		GhostInstance.flip_v = PlayerSprite.flip_v
		GhostInstance.position = global_position
		ghostCounter = 0

func _on_shot_timer_timeout():
	IsShooting = false

func handle_horizontal():
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	PlayerSprite.flip_h = velocity.x > 0
	
	velocity.x = speed * input_direction_x
