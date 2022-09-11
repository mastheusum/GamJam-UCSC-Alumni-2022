extends Spatial

export var target : NodePath
var _target_follow : KinematicBody
var _mouse_pressed : bool = false
var _mouse_motion : int = 0
var _deltaR : float = 0

func _ready():
	_target_follow = get_node(target)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed():
				_mouse_pressed = true
			else:
				_mouse_pressed = false
				_deltaR = 0
	elif event is InputEventMouseMotion:
		if _mouse_pressed:
			var relative = event.speed
			relative.y = 0
			_deltaR = - relative.normalized().x

func _process(delta):
	if _target_follow:
		translation = _target_follow.translation
		global_rotate(Vector3.UP, _deltaR * delta)
