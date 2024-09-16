extends Control
class_name PauseMenu

@onready var return_button = $PanelContainer/MarginContainer/ReturnButton


func _input(event):
	if event.is_action("pause"):
		visible = !visible
