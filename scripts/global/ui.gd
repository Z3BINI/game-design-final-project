extends CanvasLayer


@onready var player_hp = $PlayerHp
@onready var game_over = $FishEyeShaderEffect/FullScreen/GameOver
@onready var pause_menu = $FishEyeShaderEffect/FullScreen/PauseMenu


func _on_quack_man_world_game_over():
	await get_tree().create_timer(5).timeout
	
	game_over.visible = true

func _on_retry_button_pressed():
	get_tree().reload_current_scene()
