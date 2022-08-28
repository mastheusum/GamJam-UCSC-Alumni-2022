extends Camera

var target : KinematicBody = null

func _ready():
	rotation_degrees.y = 180
	rotation_degrees.x = -45

func _process(delta):
	if target:
		translation = target.translation + Vector3(0, 12, -9)
	
