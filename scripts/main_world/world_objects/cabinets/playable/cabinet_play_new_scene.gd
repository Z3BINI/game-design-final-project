extends StaticBody3D

var quack_game : PackedScene = preload("res://scenes/quack_world/quack_man_world.tscn")
var pool_game : PackedScene = preload("res://scenes/insane_pool/crazy_pool.tscn")

var player_near : bool = false
enum game {QUACK, POOL}

@export var this_game : game

func _input(event : InputEvent):
	if (player_near and event.is_action_pressed("interact")):
		match (this_game):
			game.QUACK:
				get_tree().change_scene_to_packed(quack_game)
			game.POOL:
				get_tree().change_scene_to_packed(pool_game)

func _on_play_game_trigger_body_entered(body : Player3d):
	match (this_game):
			game.QUACK:
				body.toggle_hud_label(true, "Press [E] to play QUACK-MAN!")
			game.POOL:
				body.toggle_hud_label(true, "Press [E] to play INSANE-POOL!")
	player_near = true


func _on_play_game_trigger_body_exited(body : Player3d):
	body.toggle_hud_label(false)
	player_near = false
