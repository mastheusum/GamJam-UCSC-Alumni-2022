extends CanvasLayer

func _on_Options_pressed():
	$Menu.visible = not $Menu.visible
	get_tree().paused = $Menu.visible
