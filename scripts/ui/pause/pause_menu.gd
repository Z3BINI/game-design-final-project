extends Control
class_name PauseMenu

@onready var return_button = $PanelContainer/MarginContainer/ReturnButton

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
