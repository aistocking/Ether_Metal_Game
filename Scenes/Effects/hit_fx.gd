extends Node2D


const _hit_spark: PackedScene = preload("res://Scenes/Effects/hit_spark.tscn")

func _ready():
	var instance1 = _hit_spark.instantiate()
	instance1.streak_number = 0
	add_child(instance1)
	var instance2 = _hit_spark.instantiate()
	instance2.streak_number = 0
	add_child(instance2)
	var instance3 = _hit_spark.instantiate()
	instance3.streak_number = 0
	add_child(instance3)
	var instance4 = _hit_spark.instantiate()
	instance4.streak_number = 0
	add_child(instance4)
	var instance5 = _hit_spark.instantiate()
	instance5.streak_number = 0
	add_child(instance5)
	var instance6 = _hit_spark.instantiate()
	instance6.streak_number = 0
	add_child(instance6)
	
	global_position += Vector2(randi_range(-3, 3), randi_range(-3, 3))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_life_time_timeout():
	queue_free()
