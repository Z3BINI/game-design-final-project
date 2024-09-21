extends CardUpgrade

func use():
	player.unlocked_egg = true
	
	choice_done.emit(id)
