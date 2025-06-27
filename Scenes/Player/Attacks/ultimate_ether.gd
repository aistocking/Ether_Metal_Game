extends Node2D

var _player

signal full_fire
signal done
# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	_player.energy_drain = true
	_player.connect("energy_lost", stop)
	if _player.facing_direction == -1:
		$Projectile/flying_dust.texture = load("res://Art/Effects/Flying_Dust_Flip.png")
	%anims.play("Start")
	%anims.queue("Blast")
	%anims.queue("Loop")

func stop() -> void:
	%anims.play("End")
	await %anims.animation_finished
	queue_free()
