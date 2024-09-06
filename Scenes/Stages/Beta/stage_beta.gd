extends Node2D


var DialogueBoxResource: Resource = preload("res://Scenes/Misc/text_box.tscn")


func _ready() -> void:
	Global.change_music("res://Sound/Music/06_Opening Stage X.mp3")
	RenderingServer.set_default_clear_color(Color(0,0,0))


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	add_child(DialogueBoxInst)
	$CutsceneTrigger.queue_free()
