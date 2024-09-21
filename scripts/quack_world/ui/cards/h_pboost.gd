extends CardUpgrade

func use():
	player.upgrade_hp()
	
	choice_done.emit(id)
