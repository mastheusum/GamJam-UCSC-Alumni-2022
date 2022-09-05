extends KinematicBody

const GRAVITY = -2
var velocity := Vector3()
var dir := Vector3()
var speed = 4
var jump_power = 32

var _is_on_walk : bool = false
var _rotate = 0 # radians
var _snap := Vector3()
var on_destiny : bool = true
onready var anim := $AnimationTree

func _on_navigation_finished():
	velocity = Vector3.ZERO
	print('Finished')
	var x = -5 + (randi() % 10)
	var z = -5 + (randi() % 10)
	$NavAgent.set_target_location(
		global_transform.origin + Vector3(x, 0, z)
	)
	on_destiny = false

func _on_target_reached():
	velocity = Vector3.ZERO
	print('Reached')

func _on_velocity_computed(safe_velocity):
	velocity = move_and_slide(safe_velocity)

func _ready():
	var agent_rid = $NavAgent.get_rid()
	var map_rid = get_parent().get_world().get_navigation_map()
	print(agent_rid, ' -> ', map_rid)
	NavigationServer.agent_set_map(agent_rid, map_rid)
	randomize()
	var x = -5 + (randi() % 10)
	var z = -5 + (randi() % 10)
	$NavAgent.set_target_location(
		global_transform.origin + Vector3(x, 0, z)
	)
	on_destiny = false

func _physics_process(delta):
	if on_destiny:
		return
	var next = $NavAgent.get_next_location()
	velocity = global_transform.origin.direction_to(next)
	velocity.y = 0
	$NavAgent.set_velocity(velocity.normalized() * speed)
	if velocity.length() > 0.5:
		$Enemy.look_at(Vector3(
			global_transform.origin.x - velocity.x,
			$Enemy.global_transform.origin.y,
			global_transform.origin.z - velocity.z
		), Vector3.UP)
	animate()

func animate():
	anim['parameters/conditions/idle'] = velocity.length() < 0.5
	anim['parameters/conditions/walk'] = not (velocity.length() < 0.5)
