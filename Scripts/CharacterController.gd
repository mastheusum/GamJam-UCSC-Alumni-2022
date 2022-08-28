extends KinematicBody

class_name Character

const GRAVITY = -2
var velocity := Vector3()
var dir := Vector3()
var speed = 10
var jump_power = 32

var _is_on_jump : bool = false
var _is_on_walk : bool = false
var _rotate = 0 # radians
var _snap := Vector3()
onready var anim := $AnimationTree

var coins : int = 0

func _physics_process(delta):
	velocity.y += GRAVITY
	if is_on_floor():
		_is_on_jump = false
		if Input.is_action_just_pressed("ui_jump"):
			velocity.y = jump_power
			_is_on_jump = true
	
	dir = global_transform.basis.z * Input.get_action_raw_strength("ui_up")
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	_is_on_walk = (dir.x != 0 or dir.z != 0)
	
	_rotate = Input.get_action_raw_strength("ui_left") - Input.get_action_raw_strength("ui_right")
	global_rotate( Vector3.UP, _rotate * delta )
	
	_snap = Vector3.DOWN if not _is_on_jump else Vector3.ZERO
	velocity = move_and_slide_with_snap(velocity, _snap, Vector3.UP, true)
	animate()

func animate():
	anim['parameters/conditions/walkAnim'] = _is_on_walk and not _is_on_jump
	anim['parameters/conditions/jumpAnim'] = _is_on_jump
	anim['parameters/conditions/idle'] = not (_is_on_walk or _is_on_jump)

func add_coin(amount = 1):
	coins += amount
