extends CharacterBody2D


const speed: int = 200
var damage: int = 5
var direction
var drag: float = 0
var tween

var closestEnemy

func _ready():
	velocity.x = 100 * direction
	tween = get_tree().create_tween()
	tween.tween_property(self, "drag", .75, 2).set_trans(Tween.TRANS_CUBIC)
	var enemyArray = get_tree().get_nodes_in_group("Enemies")
	var temp: float = 0
	var tempPrev: float = 0
	for enemy in enemyArray:
		temp = position.distance_to(enemy.position)
		if temp < tempPrev || tempPrev == 0:
			closestEnemy = enemy
		tempPrev = temp

func _physics_process(delta):
	var desiredVelocity = global_position.direction_to(closestEnemy.global_position) * speed
	velocity += (desiredVelocity - velocity) * drag
	move_and_slide()

func getDirection(dir):
	direction = dir

func _on_death_timer_timeout():
	queue_free()
