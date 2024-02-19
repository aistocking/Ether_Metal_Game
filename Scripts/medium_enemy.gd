extends Area2D

const ExplosionEffect = preload("res://Scenes/Effects/medium_explosion.tscn")
const EnemyShot = preload("res://Scenes/Enemies/enemy_shot.tscn")

var health : int = 5
var FacingDirection : int = -1

@onready var AnimPlayer = $AnimationPlayer
@onready var Sprite = $Sprite2D
@onready var WaitTimer = $WaitTimer
@onready var VisionCone = $VisionCone
@onready var DebugStateLabel = $DebugStateLabel

enum STATE {IDLE, WALK, AIM, SHOOT, HIT, DEATH}

var currentState

# Called when the node enters the scene tree for the first time.
func _ready():
	stateChange(STATE.IDLE)

# TODO shouldn't this be in the physics_process?
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(currentState == STATE.WALK):
		position.x +=  FacingDirection * 2
	

func stateChange(state):
	match state:
		STATE.IDLE:
			currentState = STATE.IDLE
			AnimPlayer.stop()
			Sprite.frame = 0
			WaitTimer.start(0.8)
			DebugStateLabel.text = "IDLE"
		STATE.WALK:
			currentState = STATE.WALK
			AnimPlayer.play("Walk")
			WaitTimer.start(1.2)
			DebugStateLabel.text = "WALK"
		STATE.AIM:
			currentState = STATE.AIM
			AnimPlayer.play("PrepareShot")
			DebugStateLabel.text = "AIM"
		STATE.SHOOT:
			currentState = STATE.SHOOT
			WaitTimer.stop()
			AnimPlayer.play("Shooting")
			shoot()
			DebugStateLabel.text = "SHOOT"
		STATE.HIT:
			AnimPlayer.stop()
			Sprite.frame = 9
			WaitTimer.start(0.3)
			DebugStateLabel.text = "HIT"
		STATE.DEATH:
			currentState = STATE.DEATH
			DebugStateLabel.text = "DIE"
			die()

func die():
	var ExplosionInstance = ExplosionEffect.instantiate()
	get_parent().add_child(ExplosionInstance)
	ExplosionInstance.position = global_position
	queue_free()

func takeDamage(damage):
	health -= damage
	if(health <= 0):
		stateChange(STATE.DEATH)
	else:
		stateChange(STATE.HIT)

func turnAround():
	FacingDirection = FacingDirection * -1
	Sprite.flip_h = !Sprite.flip_h
	VisionCone.scale.x = VisionCone.scale.x * -1
	if(currentState == STATE.IDLE):
		stateChange(STATE.WALK)
	elif(currentState == STATE.WALK):
		stateChange(STATE.IDLE)

func shoot():
	var ShotInstance = EnemyShot.instantiate()
	get_parent().add_child(ShotInstance)
	ShotInstance.position = global_position
	ShotInstance.getDirection(Vector2(FacingDirection, 0))
	WaitTimer.start(0.15)

#func _on_area_entered(area):
#	if(area.is_in_group("PlayerProjectiles")):
#		takeDamage()

func _on_wait_timer_timeout():
	match currentState:
		STATE.IDLE:
			turnAround()
			stateChange(STATE.WALK)
		STATE.HIT:
			stateChange(STATE.IDLE)
		STATE.WALK:
			stateChange(STATE.IDLE)
		STATE.HIT:
			stateChange(STATE.IDLE)
		STATE.AIM:
			stateChange(STATE.SHOOT)
		STATE.SHOOT:
			if(VisionCone.overlaps_body(get_tree().get_first_node_in_group("Player"))):
				stateChange(STATE.SHOOT)
			else:
				stateChange(STATE.IDLE)

func _on_vision_cone_body_entered(_body):
	stateChange(STATE.AIM)
	WaitTimer.start(0.3)

func _on_vision_cone_body_exited(_body):
	WaitTimer.start(0.5)
