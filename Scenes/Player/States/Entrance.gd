extends State


var player: CharacterBody2D
var IntroComplete : bool = false

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerAnimations.play("Entrance")
	player.PlayerAnimations.stop()
	var Announcer = get_tree().get_first_node_in_group("ReadyAnnounce")
	Announcer.IntroFinished.connect(self.introDone)

func physics_update(delta: float) -> void:
	if IntroComplete:
		if !player.is_on_floor():
			player.velocity.y = 500
			player.move_and_slide()
		else:
			player.velocity.y = 0
			player.PlayerAnimations.play("Entrance")
		

func introDone():
	IntroComplete = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Entrance":
		state_machine.transition_to("Idle")
