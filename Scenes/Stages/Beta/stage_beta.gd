extends Node2D


var DialogueBoxResource: Resource = preload("res://Scenes/Misc/text_box.tscn")

var _bg_gate1 := false
var _bg_gate2 := false

@onready var bg_trigger2 := $StageTriggers/BGTrigger2

@onready var _stage_bgm: AudioStream = preload("res://Sound/Music/Svarog_Stage_BGM.mp3")
@onready var _enemy: PackedScene = preload("res://Scenes/Enemies/base_enemy.tscn")

func _ready() -> void:
	Global.change_music(_stage_bgm)
	Global.debug_mode()
	RenderingServer.set_default_clear_color(Color(0,0,0))


func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	add_child(DialogueBoxInst)
	$StageTriggers/CutsceneTrigger.queue_free()

func _on_bg_trigger_1_body_entered(body):
	$BGs/BGRamps.visible = true
	$BGs/MGRamps.visible = true
	$BGs/MGGirders.visible = false

func _on_bg_trigger_2_body_entered(body):
	$BGs/BGRamps.visible = true
	$BGs/MGRamps.visible = false
	$BGs/MGGirders.visible = true
