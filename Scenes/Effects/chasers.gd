class_name Chasers
extends CharacterBody2D


const speed: int = 200
var damage: int = 5
var direction
var drag: float = 0
var tween1
var tween2

var closestEnemy

func _ready():
	velocity = speed * direction
	tween1 = get_tree().create_tween()
	tween1.tween_property(self, "drag", .75, 2).set_trans(Tween.TRANS_CUBIC)
	findClosestEnemy()

func _physics_process(delta):
	if closestEnemy == null:
		findClosestEnemy()
	else:
		var desiredVelocity = global_position.direction_to(closestEnemy.global_position) * speed
		velocity += (desiredVelocity - velocity) * drag
	move_and_slide()

func findClosestEnemy():
	var enemyArray = get_tree().get_nodes_in_group("Enemies")
	var temp: float = 0
	var tempPrev: float = 0
	for enemy in enemyArray:
		temp = position.distance_to(enemy.position)
		if temp < tempPrev || tempPrev == 0:
			closestEnemy = enemy
		tempPrev = temp

func getDirection(dir):
	direction = dir


func _on_area_2d_area_entered(area):
	if(area.has_method("takeDamage")):
		area.takeDamage(damage)
		queue_free()

func _on_area_2d_body_entered(body):
	if(body.has_method("takeDamage")):
		body.takeDamage(damage)
		queue_free()
