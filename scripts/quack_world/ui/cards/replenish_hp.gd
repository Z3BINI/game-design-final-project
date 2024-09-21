extends CardUpgrade

func use():
	player.replenish_hp()
	
	choice_done.emit(id)
