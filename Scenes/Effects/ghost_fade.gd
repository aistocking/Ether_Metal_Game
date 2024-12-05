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

func set_sprite_nodes(bgArm, bgLeg, body, head, fgLeg, fgArm) -> void:
	_player_bg_arm_sprite.texture = bgArm.texture
	_player_bg_leg_sprite.texture = bgLeg.texture
	_player_body_sprite.texture = body.texture
	_player_head_sprite.texture = head.texture
	_player_fg_leg_sprite.texture = fgLeg.texture
	_player_fg_arm_sprite.texture = fgArm.texture

	_player_bg_arm_sprite.hframes = fgArm.hframes
	_player_bg_leg_sprite.hframes = fgArm.hframes
	_player_body_sprite.hframes = fgArm.hframes
	_player_head_sprite.hframes = fgArm.hframes
	_player_fg_leg_sprite.hframes = fgArm.hframes
	_player_fg_arm_sprite.hframes = fgArm.hframes

	_player_bg_arm_sprite.vframes = fgArm.vframes
	_player_bg_leg_sprite.vframes = fgArm.vframes
	_player_body_sprite.vframes = fgArm.vframes
	_player_head_sprite.vframes = fgArm.vframes
	_player_fg_leg_sprite.vframes = fgArm.vframes
	_player_fg_arm_sprite.vframes = fgArm.vframes

	_player_bg_arm_sprite.frame = fgArm.frame
	_player_bg_leg_sprite.frame = fgArm.frame
	_player_body_sprite.frame = fgArm.frame
	_player_head_sprite.frame = fgArm.frame
	_player_fg_leg_sprite.frame = fgArm.frame
	_player_fg_arm_sprite.frame = fgArm.frame

	_player_bg_arm_sprite.flip_h = fgArm.flip_h
	_player_bg_leg_sprite.flip_h = fgArm.flip_h
	_player_body_sprite.flip_h = fgArm.flip_h
	_player_head_sprite.flip_h = fgArm.flip_h
	_player_fg_leg_sprite.flip_h = fgArm.flip_h
	_player_fg_arm_sprite.flip_h = fgArm.flip_h

func on_tween_finished():
	queue_free()
