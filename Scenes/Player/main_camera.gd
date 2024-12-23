extends Camera2D

var _player: PlayerCharacter
var origin

var _rng = RandomNumberGenerator.new()

var _shake_strength: float = 0.0

func _ready():
	origin = global_position
	_player = get_tree().get_first_node_in_group("Player")
	_player.connect("screen_shake", apply_shake)

func _physics_process(_delta):
	position = _player.position
	position.y -= 15
	
	
	if _shake_strength > 0.0:
		offset = _random_offset()


func apply_shake(strength: float, time: float) -> void:
	_shake_strength = strength
	create_tween().tween_property(self, "_shake_strength", 0.0, time)

func _random_offset() -> Vector2:
	return Vector2(_rng.randf_range(-_shake_strength, _shake_strength), _rng.randf_range(-_shake_strength, _shake_strength))

#With the proper 2D position markers from camera_bounds scene, hand over the global_position of each along with a transition time
#Then transition from the old limits to the new ones with the transition time
func change_camera_limits(bottomLeft: Vector2, topRight: Vector2, transitionTime: float, doorTransition: bool):
	if doorTransition:
		var tweenTop = self.create_tween().tween_property(self, "limit_top", topRight.y, transitionTime).set_trans(Tween.TRANS_EXPO)
		var tweenRight = self.create_tween().tween_property(self, "limit_right", topRight.x, transitionTime).set_trans(Tween.TRANS_EXPO)
		limit_bottom = bottomLeft.y
		limit_left = bottomLeft.x
	else:
		var tweenTop = self.create_tween().tween_property(self, "limit_top", topRight.y, transitionTime).set_trans(Tween.TRANS_EXPO)
		var tweenBottom = self.create_tween().tween_property(self, "limit_bottom", bottomLeft.y, transitionTime).set_trans(Tween.TRANS_EXPO)
		var tweenLeft = self.create_tween().tween_property(self, "limit_left", bottomLeft.x, transitionTime).set_trans(Tween.TRANS_EXPO)
		var tweenRight = self.create_tween().tween_property(self, "limit_right", topRight.x, transitionTime).set_trans(Tween.TRANS_EXPO)
	
