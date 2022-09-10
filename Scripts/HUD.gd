extends CanvasLayer

#var player : Character

#func set_player(character):
#	player = character

#func _process(delta):
#	if player:
#		$Coins/Value.bbcode_text = "[center]" + str(player.coins)

func set_coins(total : int):
	$Coins/Value.bbcode_text = "[center]" + str(total)

func set_life(life : float):
	$Hearts/First.value = life
	$Hearts/Second.value = life
	$Hearts/Third.value = life
