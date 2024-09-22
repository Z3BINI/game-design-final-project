extends Control
class_name Score

@export var multiplier_max : int = 10

@onready var score_label: Label = $ScoreLabel
@onready var multiplier_time: ProgressBar = $MultiplierTime
@onready var multiplier: Label = $MultiplierTime/Multiplier
@onready var multiplier_cd: Timer = $MultiplierCD

var current_multiplier : int = 1
var current_score : int = 0

func _ready() -> void:
	multiplier_time.max_value = multiplier_cd.wait_time
	multiplier_time.value = multiplier_cd.wait_time


func _physics_process(delta: float) -> void:
	score_label.text = str(current_score)
	if multiplier_time.visible:
		multiplier_time.value = multiplier_cd.time_left


func update_score(amount : int):
	if !multiplier_time.visible:
		multiplier_time.visible = true

	multiplier_cd.start()
		
	current_score += (current_multiplier * amount)
	
	if current_multiplier != multiplier_max:
		multiplier.text = "x" + str(current_multiplier+1)
		current_multiplier += 1
	else:
		multiplier.text = "x" + str(current_multiplier)
	
func _on_multiplier_cd_timeout() -> void:
	if current_multiplier - 1 != 1:
		current_multiplier -= 1
		multiplier.text = "x" + str(current_multiplier)
		multiplier_cd.stop()
		multiplier_cd.start()
	else:
		multiplier_time.visible = false
		current_multiplier = 1
		multiplier_cd.stop()
