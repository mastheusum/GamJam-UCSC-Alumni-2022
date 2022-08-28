extends Area

func _physics_process(delta):
	global_rotate(Vector3.UP, delta)

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		(body as Character).add_coin(1)
		queue_free()
