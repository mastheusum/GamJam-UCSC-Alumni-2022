extends Spatial

var target : KinematicBody
var anim : AnimationTree
var agent : NavigationAgent

func _ready():
	$PerceptionZone.connect("body_entered", self, "_on_PerceptionZone_body_entered")
	$PerceptionZone.connect("body_exited", self, "_on_PerceptionZone_body_exited")
	$AttackZone.connect("body_entered", self, "_on_AttackZone_body_entered")
	$AttackZone.connect("body_exited", self, "_on_AttackZone_body_exited")
	anim = $"../AnimationTree"
	agent = $"../NavAgent"
	randomize()

func _process(delta):
	if target:
		$BehaviorTree['parameters/conditions/notTarget'] = false
		$BehaviorTree['parameters/conditions/target'] = true
	else:
		$BehaviorTree['parameters/conditions/notTarget'] = true
		$BehaviorTree['parameters/conditions/target'] = false

func _set_attack(attacking : bool):
	anim['parameters/Attack/blend_amount'] = 1 if attacking else 0

func _set_walk(walking : bool):
	anim['parameters/Walk/blend_amount'] = 1 if walking else 0

func play_attack():
	_set_attack(true)
	_set_walk(false)

func play_walk():
	_set_attack(false)
	_set_walk(true)

func play_idle():
	_set_attack(false)
	_set_walk(false)

func find_target(active : bool):
	$PerceptionZone/CollisionShape.disabled = not active
	if active:
		get_parent().set_target(
			global_transform.origin
		)

func set_random_direction():
	var end := Vector3()
	end.x = -5 + (randi() % 10)
	end.z = -5 + (randi() % 10)
	get_parent().set_target(end)

func set_target_direction():
	var end := Vector3()
	end.x = target.global_transform.origin.x
	end.z = target.global_transform.origin.z 
	get_parent().set_target(end)

func _on_PerceptionZone_body_entered(body : Node):
	if body.is_in_group("Player"):
		target = body

func _on_PerceptionZone_body_exited(body : Node):
	if body.is_in_group("Player"):
		if target == body:
			target = null

func _on_AttackZone_body_entered(body : Node):
	if body.is_in_group("Player"):
		$BehaviorTree['parameters/conditions/can_attack'] = true

func _on_AttackZone_body_exited(body : Node):
	if body.is_in_group("Player"):
		$BehaviorTree['parameters/conditions/can_attack'] = false

func set_damage():
	(target as Character).damaged(0.5)
