extends Node2D

@onready var _player: PlayerCharacter = get_tree().get_first_node_in_group("Player")
@onready var POD_MUSIC: AudioStream = preload("res://Sound/Music/21. Dr. Light.mp3")
var DialogueBoxResource: Resource = preload("res://Scenes/Misc/text_box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_trigger_body_entered(body):
	Global.acquire_armor(Global.Armors.Arms)
	_player.set_armour_peices()
	$Sprite2D.frame = 2
	$Trigger.queue_free()
	


func _on_cutscene_trigger_body_entered(body):
	var DialogueBoxInst = DialogueBoxResource.instantiate()
	DialogueBoxInst.new_music = POD_MUSIC
	add_child(DialogueBoxInst)
	$CutsceneTrigger.queue_free()
