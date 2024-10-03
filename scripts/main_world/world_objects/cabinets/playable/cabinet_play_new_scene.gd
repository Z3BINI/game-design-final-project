extends StaticBody3D

var game : PackedScene = load("res://scenes/quack_world/quack_man_world.tscn")

var player_near : bool = false

func _input(event : InputEvent):
	if (player_near and event.is_action_pressed("interact")):
		get_tree().change_scene_to_packed(game)

func _on_play_game_trigger_body_entered(body : Player3d):
	body.toggle_hud_label(true, "Press [E] to play QUACK-MAN!")
	player_near = true


func _on_play_game_trigger_body_exited(body : Player3d):
	body.toggle_hud_label(false)
	player_near = false
