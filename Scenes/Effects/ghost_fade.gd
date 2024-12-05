class_name GhostFade
extends Node2D

@onready var player_sprite: CanvasGroup = $CanvasGroup
@onready var _player_head_sprite : Sprite2D = $CanvasGroup/Head
@onready var _player_body_sprite : Sprite2D = $CanvasGroup/Body
@onready var _player_bg_leg_sprite : Sprite2D = $CanvasGroup/BGLeg
@onready var _player_fg_leg_sprite : Sprite2D = $CanvasGroup/FGLeg
@onready var _player_bg_arm_sprite : Sprite2D = $CanvasGroup/BGArm
@onready var _player_fg_arm_sprite : Sprite2D = $CanvasGroup/FGArm

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, .3)
	tween.connect("finished", on_tween_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_sprite_nodes(bgArm: Sprite2D, bgLeg: Sprite2D, body: Sprite2D, head: Sprite2D, fgLeg: Sprite2D, fgArm: Sprite2D) -> void:
	player_sprite.add_child(bgArm.duplicate(8))
	player_sprite.add_child(bgLeg.duplicate(8))
	player_sprite.add_child(body.duplicate(8))
	player_sprite.add_child(head.duplicate(8))
	player_sprite.add_child(fgLeg.duplicate(8))
	player_sprite.add_child(fgArm.duplicate(8))

func on_tween_finished():
	queue_free()
