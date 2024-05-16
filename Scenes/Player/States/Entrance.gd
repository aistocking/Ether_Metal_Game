extends State


var player: CharacterBody2D
var IntroComplete : bool = false

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.player_animations.play("Entrance")
	player.player_animations.stop()
	var Announcer = get_tree().get_first_node_in_group("ReadyAnnounce")
	if Announcer == null:
		introDone()
	else:
		Announcer.IntroFinished.connect(self.introDone)

func physics_update(delta: float) -> void:
	if IntroComplete:
		if !player.is_on_floor():
			player.velocity.y = 500
			player.move_and_slide()
		else:
			player.velocity.y = 0
			player.player_animations.play("Entrance")
		

func introDone():
	IntroComplete = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Entrance":
		player.change_player_control(true)
		state_machine.transition_to("Idle")
