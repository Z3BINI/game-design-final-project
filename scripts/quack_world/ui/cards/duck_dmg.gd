extends CardUpgrade

func use():
	player.duck_upgrade("shot_dmg", 0.3)
	
	choice_done.emit(id)
