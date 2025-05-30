extends Node2D


@onready var _stage_bgm: AudioStream = preload("res://Sound/Music/Svarog_Stage_BGM.mp3")
var _dialog_resource: Resource = preload("res://Scenes/Misc/text_box.tscn")


func _ready() -> void:
	Global.change_music(_stage_bgm)
	Global.debug_mode()
	RenderingServer.set_default_clear_color(Color(0,0,0))


func _on_area_2d_body_entered(_body: Node2D) -> void:
	var dialog: Node = _dialog_resource.instanciate()
	add_child(dialog)
	%CutsceneTrigger.queue_free()


func _on_bg_trigger_1_body_entered(body):
	%Zone1.visible = true
	%Zone2.visible = false


func _on_bg_trigger_2_body_entered(body):
	%Zone1.visible = false
	%Zone2.visible = true
