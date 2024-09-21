extends CardUpgrade

func use():
	player.current_egg_dmg += (player.current_egg_dmg * 0.10)
	
	choice_done.emit(id)
