extends CardUpgrade

func use():
	player.duck_upgrade("shot_cd", 0.3)
	
	choice_done.emit(id)
