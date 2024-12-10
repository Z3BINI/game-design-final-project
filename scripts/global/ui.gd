extends CanvasLayer

var main_world : PackedScene = load("res://scenes/main_world/arcade_room.tscn")

@onready var difficulty_time_left: Label = $FishEyeShaderEffect/FullScreen/TimeLeft/TimeLeft
@onready var player_hp: TextureProgressBar = $FishEyeShaderEffect/FullScreen/PlayerHp
@onready var game_over = $FishEyeShaderEffect/FullScreen/GameOver
@onready var pause_menu = $FishEyeShaderEffect/FullScreen/PauseMenu
@onready var animation_player = $AnimationPlayer
@onready var card_choice_screen = $FishEyeShaderEffect/FullScreen/CardChoiceScreen
@onready var time_left_ui: Control = $FishEyeShaderEffect/FullScreen/TimeLeft
@onready var reload_bar: TextureProgressBar = $FishEyeShaderEffect/FullScreen/ReloadUi/ReloadBar
@onready var reload_ui: TextureRect = $FishEyeShaderEffect/FullScreen/ReloadUi
@onready var reload_bar_egg: TextureProgressBar = $FishEyeShaderEffect/FullScreen/ReloadUi2/ReloadBar
@onready var reload_ui_egg: TextureRect = $FishEyeShaderEffect/FullScreen/ReloadUi2



var level_difficulty_timer : Timer
var reload_timer : SceneTreeTimer
var egg_reload_timer : SceneTreeTimer

func _process(delta: float) -> void:
	
	if (reload_bar.value > 0 and reload_timer != null):
		reload_bar.value = reload_timer.time_left
	if (reload_bar_egg.value > 0 and egg_reload_timer != null):
		reload_bar_egg.value = egg_reload_timer.time_left
	
	reload_ui.visible = (reload_bar.value != 0)
	reload_ui_egg.visible = (reload_bar_egg.value != 0)
	time_left_ui.visible = !card_choice_screen.visible
	
	if (level_difficulty_timer):
		difficulty_time_left.text = str("%.0f" % level_difficulty_timer.time_left)

func set_reload_bar(amount : float):
	reload_bar.max_value = amount
	reload_bar.value = amount
	
func set_egg_bar(amount : float):
	reload_bar_egg.max_value = amount
	reload_bar_egg.value = amount


func _on_quack_man_world_game_over():
	await get_tree().create_timer(5).timeout
	$FishEyeShaderEffect/FullScreen/GameOver/Score.text = "SCORE: " + $FishEyeShaderEffect/FullScreen/Score/ScoreLabel.text
	game_over.visible = true

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_player_player_damaged():
	animation_player.play("player_took_dmg")

func on_egg_explosion():
	animation_player.play("screen_shake")

func _on_quit_button_pressed():
	get_tree().change_scene_to_packed(main_world)
