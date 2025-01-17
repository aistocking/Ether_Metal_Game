class_name EtherFire
extends AnimatedSprite2D


var _damage: int = 4
var _stun_damage: int = 1
var _power: float = 200
var _hit_direction: Vector2 = Vector2(0, -1)


func _ready() -> void:
	$HitBox.set_variables(_damage, _stun_damage, _hit_direction, _power)

func _on_death_timer_timeout():
		queue_free()

func _on_reset_hit_box_timeout():
	$HitBox/HitCollision.disabled = !$HitBox/HitCollision.disabled
