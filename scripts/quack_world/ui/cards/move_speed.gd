extends CardUpgrade

func use():
	player.current_max_speed += (0.12 * player.current_max_speed)
	
	choice_done.emit(id)
