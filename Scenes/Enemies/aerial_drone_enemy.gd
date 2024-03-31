extends CharacterBody2D

var Player

func _ready():
	Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	position = position.move_toward(Player.position, 50 * delta)
	move_and_slide()
