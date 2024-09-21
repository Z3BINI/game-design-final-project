extends CardUpgrade

func use():
	player.current_egg_cd -= (player.current_egg_cd * 0.1)
	
	choice_done.emit(id)
