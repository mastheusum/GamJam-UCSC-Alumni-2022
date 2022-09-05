extends CanvasLayer

var player : Character

func set_player(character):
	player = character

func _process(delta):
	if player:
		$Coins/Value.bbcode_text = "[center]" + str(player.coins)
