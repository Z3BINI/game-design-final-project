extends StaticBody3D


func _on_play_game_trigger_body_entered(body : Player3d):
	body.toggle_hud_label(true, "Press [E] to play QUACK-MAN!")


func _on_play_game_trigger_body_exited(body : Player3d):
	body.toggle_hud_label(false)
