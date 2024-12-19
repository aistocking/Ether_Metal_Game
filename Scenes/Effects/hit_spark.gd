extends Node2D

@export var streak_number: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.position.x = randi_range(5, 9)
	var current_animation: String = "default"
	match streak_number:
		0:
			rotation = randi_range(20, 40)
		1:
			rotation = randi_range(80, 100)
		2:
			rotation = randi_range(140, 160)
		3:
			rotation = randi_range(200, 220)
		4:
			rotation = randi_range(260, 300)
		5:
			rotation = randi_range(320, 340)
	if randi_range(0, 10) > 7:
		$AnimatedSprite2D.animation = "fat"
		current_animation = "fat"
	if randi_range(0, 1) == 1:
		$AnimatedSprite2D.play(current_animation, 1.5, false)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
