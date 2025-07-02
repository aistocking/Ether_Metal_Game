class_name BounceCollider
extends Area2D

@onready var _bouncy_collision: CollisionShape2D = $BouncyCollision
@onready var _parent_self:BasicEnemy = get_parent()
var _self_hurt_box: HurtBox
var _enemy_box_ref: Rect2
var _box_size_ref: Vector2
var _top_left: Vector2
var _bottom_right: Vector2
var _rectangle_shape: RectangleShape2D
var _top_bottom_shape_size: Vector2
var _left_right_shape_size: Vector2

signal  wall_bounce

func _ready() -> void:
	_self_hurt_box = get_parent().find_child("HurtBox")
	_enemy_box_ref = _self_hurt_box.get_child(0).shape.get_rect()
	_top_left = _enemy_box_ref.position
	_bottom_right =_enemy_box_ref.end
	_rectangle_shape = RectangleShape2D.new()
	_rectangle_shape.size = Vector2.ZERO
	_bouncy_collision.shape = _rectangle_shape
	_box_size_ref = _enemy_box_ref.size
	_top_bottom_shape_size = Vector2((_box_size_ref.x - 2), 2)
	_left_right_shape_size = Vector2(2, (_box_size_ref.y - 2))

func set_wall_bounce_collision(text: String) -> void:
	match text:
		"Top":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.size = _top_bottom_shape_size
			_bouncy_collision.position.y = _top_left.y
		"Bottom":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.size = _top_bottom_shape_size
			_bouncy_collision.position.y = _bottom_right.y
		"Right":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.size = _left_right_shape_size
			_bouncy_collision.position.x = _bottom_right.x
		"Left":
			_bouncy_collision.set_deferred("disabled", false)
			_bouncy_collision.shape.size = _left_right_shape_size
			_bouncy_collision.position.x = _top_left.x
		"Off":
			_bouncy_collision.set_deferred("disabled", true) 
			_bouncy_collision.shape.size = Vector2.ZERO
			_bouncy_collision.position = Vector2.ZERO


func _on_area_entered(area):
	if area == _self_hurt_box:
		return
	if area is HurtBox:
		if(area.has_method("take_damage")):
			area.take_damage(5, 35, Vector2(0,0), 0)
	emit_signal("wall_bounce")


func _on_body_entered(body):
	if body == _parent_self:
		return
	emit_signal("wall_bounce")
