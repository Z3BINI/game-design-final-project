extends Sprite2D

@onready var speech_bubble_pos = $"../DuckyPivot/Ducky/SpeechBubblePos"

func _physics_process(delta):
	global_position = speech_bubble_pos.global_position 
