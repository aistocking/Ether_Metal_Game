class_name Shot
extends Area2D

var direction
var _speed: float = 7
var _damage: int = 1

@onready var SFXPlayer = $SFXPlayer
var HitSFX = preload("res://Sound/BusterShotHit.wav")
const _hit_fx: PackedScene = preload("res://Scenes/Effects/shot_effect.tscn")

func _ready():
	SFXPlayer.set_stream(HitSFX)
	$Sprites.frame = randi_range(0,4)

func _physics_process(_delta):
	position += direction * _speed

func getDirection(vec):
	direction = vec

func flip(val):
	$Sprites.flip_h = val

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = global_position
	if(area.has_method("take_damage")):
		area.take_damage(_damage)
		_hit()
	else:
		queue_free()

func _on_body_entered(body):
	var hitFX = _hit_fx.instantiate()
	hitFX.flip_h = !$Sprites.flip_h
	get_parent().add_child(hitFX)
	hitFX.global_position = global_position
	queue_free()

func _hit() -> void:
	SFXPlayer.play()
	$Sprites.queue_free()
	$CollisionShape2D.disabled = true
	_speed = 0

func _on_sfx_player_finished():
	queue_free()
