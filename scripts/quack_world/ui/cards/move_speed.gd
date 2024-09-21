extends CardUpgrade

func use():
	player.current_max_speed += (0.02 * player.current_max_speed)
	
	choice_done.emit(id)
