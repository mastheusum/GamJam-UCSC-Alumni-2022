extends KinematicBody

onready var map = get_parent().get_node("NavigationMeshInstance")
export var target_path : NodePath
var target

onready var agent_rid = $NavAgent.get_rid()

var velocity := Vector3()

func _ready():
	target = get_node(target_path) as Spatial

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_jump"):
		$NavAgent.set_target_location( target.global_transform.origin )
		var next_point = $NavAgent.get_next_location()
		var dir : Vector3 = global_transform.origin.direction_to(next_point)
		dir.y = 0
		dir = dir.normalized()
		print(dir)
		$NavAgent.set_velocity( dir * 2 )

func _on_NavAgent_velocity_computed(safe_velocity):
	velocity = safe_velocity

func _physics_process(delta):
	velocity = move_and_slide(velocity)

func _on_NavAgent_navigation_finished():
	print("Finhish")

func _on_NavAgent_target_reached():
	velocity = Vector3.ZERO
	print("Reached = Alcançado")
