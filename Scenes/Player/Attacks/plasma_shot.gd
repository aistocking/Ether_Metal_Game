class_name PlasmaShot
extends Node2D


@export var direction: Vector2:
	get:
		return %StraightProjectile.direction
	set(new_direction):
		transform = transform.rotated(new_direction.angle())
		%StraightProjectile.direction = new_direction


func _ready() -> void:
	%Sprites.frame = randi_range(0,4)


func _on_timer_timeout() -> void:
	_die()


func _on_hit(area: Area2D) -> void:
	_die()


func _die() -> void:
	%Projectile.queue_free()
	%GPUParticles2D.emitting = false
	await get_tree().create_timer(0.3).timeout
	queue_free()
