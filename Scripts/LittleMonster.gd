extends KinematicBody

class_name LittleMonster

const GRAVITY = -2
var velocity := Vector3()
var dir := Vector3()
var speed = 4
var jump_power = 32

var _is_on_walk : bool = false
var _rotate = 0 # radians
var _snap := Vector3()
var on_destiny : bool = true

func set_target(pos : Vector3):
	var my_pos = global_transform.origin
	$NavAgent.set_target_location(pos)
	on_destiny = (my_pos.x == pos.x and my_pos.y == pos.y)

func _on_navigation_finished():
	velocity = Vector3.ZERO
	on_destiny = true

func _on_target_reached():
	velocity = Vector3.ZERO
	on_destiny = true

func _on_velocity_computed(safe_velocity):
	velocity = move_and_slide(safe_velocity)

func _ready():
	var agent_rid = $NavAgent.get_rid()
	var map_rid = get_parent().get_world().get_navigation_map()
	NavigationServer.agent_set_map(agent_rid, map_rid)

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

func _on_NavAgent_path_changed():
	pass
#	print("Change > ", $NavAgent.get_nav_path()[-1])
#	if $IA.target:
#		print("Target pos > ", $IA.target.global_transform.origin)
