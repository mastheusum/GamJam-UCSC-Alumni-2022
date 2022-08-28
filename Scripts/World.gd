extends Spatial

func _ready():
	if $Camera.get_script():
		$Camera.target = $Character
