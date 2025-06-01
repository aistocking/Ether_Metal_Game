## An entity that just spawns a scene when there is a hit
##
## Not really happy with how tightly integrated this entity is. We should
## probably come back and reevaluate this entity.
class_name EffectOnHit
extends Node


@export var at: Node
@export var effect: PackedScene
@export var hit_box: HitBox


func _ready() -> void:
	hit_box.hit.connect(_on_hit)


func _on_hit() -> void:
	var parent = get_parent()
	var fx = effect.instantiate()
	fx.transform = parent.transform
	fx.global_position = (at if at else parent).global_position
	parent.get_parent().add_child(fx)
