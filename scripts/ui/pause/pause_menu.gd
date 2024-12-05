extends Control
class_name PauseMenu

var main_world : PackedScene = load("res://scenes/main_world/arcade_room.tscn")

func _input(event):
	if event.is_action_pressed("pause"):
		pause_toggle()
		
func pause_toggle():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	visible = !visible

func _on_quit_button_pressed():
	if (get_tree().current_scene.name == "ArcadeRoom"):
		get_tree().quit()
	else:
		pause_toggle()
		get_tree().change_scene_to_packed(main_world)
		
