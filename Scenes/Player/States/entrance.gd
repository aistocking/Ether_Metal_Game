extends State


var player: CharacterBody2D
var ReadyComplete : bool = false

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Entrance")
	var Announcer = get_tree().get_first_node_in_group("ReadyAnnounce")
	if Announcer == null:
		introDone()
	else:
		Announcer.IntroFinished.connect(self.introDone)

func physics_update(delta: float) -> void:
	if !player.is_on_floor():
		player.velocity.y = 500
		player.move_and_slide()
	else:
		player.velocity.y = 0

func introDone():
	ReadyComplete = true


func _on_player_anims_animation_finished(anim_name):
	if anim_name == "Entrance":
		player.change_player_control(true)
		state_machine.transition_to("Idle")
