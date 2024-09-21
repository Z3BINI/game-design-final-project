extends CardUpgrade

func use():
	player.current_basic_cd -= (player.current_basic_cd * 0.15)
	
	choice_done.emit(id)
