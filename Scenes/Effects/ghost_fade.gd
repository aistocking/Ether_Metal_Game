class_name GhostFade
extends Node2D

@onready var player_sprite: CanvasGroup = $CanvasGroup

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, .3)
	tween.connect("finished", on_tween_finished)

func set_sprite_nodes(bgArm: Sprite2D, bgLeg: Sprite2D, body: Sprite2D, head: Sprite2D, fgLeg: Sprite2D, fgArm: Sprite2D) -> void:
	player_sprite.add_child(bgArm.duplicate(8))
	player_sprite.add_child(bgLeg.duplicate(8))
	player_sprite.add_child(body.duplicate(8))
	player_sprite.add_child(head.duplicate(8))
	player_sprite.add_child(fgLeg.duplicate(8))
	player_sprite.add_child(fgArm.duplicate(8))

func on_tween_finished() -> void:
	queue_free()
