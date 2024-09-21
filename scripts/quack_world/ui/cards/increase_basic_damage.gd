extends CardUpgrade

func use():
	player.current_basic_dmg += (player.current_basic_dmg * 0.05)
	
	choice_done.emit(id)
