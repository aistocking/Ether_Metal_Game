class_name OrbitalBit
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	$Speen.rotation += 0.1
	$BitSprite.global_position = $"Speen/bit position".global_position


func _on_bit_timer_timeout():
	queue_free()
