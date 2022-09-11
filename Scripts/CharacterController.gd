extends KinematicBody

class_name Character

export var camera_offset_path : NodePath
const GRAVITY = -2
var velocity := Vector3()
var dir := Vector3()
var speed = 10
var jump_power = 32

var _life : float = 6

var _is_on_jump : bool = false
var _is_on_walk : bool = false
var _rotate = 0 # radians
var _snap := Vector3()
var _camera_offset
onready var anim := $AnimationTree

var coins : int = 0

func _ready():
	_camera_offset = get_node(camera_offset_path)
	HUD.set_coins(coins)
	HUD.set_life(_life)

func _physics_process(delta):
	velocity.y += GRAVITY
	if is_on_floor():
		_is_on_jump = false
		if Input.is_action_just_pressed("ui_jump"):
			jump()
	
	dir = _camera_offset.global_transform.basis.z * Input.get_action_raw_strength("ui_up")
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	_is_on_walk = (dir.x != 0 or dir.z != 0)
	
	if dir != Vector3.ZERO:
		look_at(global_transform.origin - dir, Vector3.UP)
	
	_snap = Vector3.DOWN if not _is_on_jump else Vector3.ZERO
	velocity = move_and_slide_with_snap(velocity, _snap, Vector3.UP, true)
	animate()

func jump(scale = 1):
	velocity.y = jump_power * scale
	_is_on_jump = true

func animate():
	anim['parameters/conditions/walkAnim'] = _is_on_walk and not _is_on_jump
	anim['parameters/conditions/jumpAnim'] = _is_on_jump
	anim['parameters/conditions/idle'] = not (_is_on_walk or _is_on_jump)

func add_coin(amount = 1):
	coins += amount
	HUD.set_coins(coins)

func damaged(value : float):
	_life -= value
	HUD.set_life(_life)
