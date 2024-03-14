extends State


var player: CharacterBody2D

func enter(_msg := {}) -> void:
	player = owner
	player.velocity = Vector2.ZERO
	player.PlayerAnimations.play("Entrance")

func update(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Entrance":
		state_machine.transition_to("Idle")
