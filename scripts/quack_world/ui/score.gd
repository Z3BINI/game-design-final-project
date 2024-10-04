extends Control
class_name Score

@export var multiplier_max : int = 10

@onready var score_label: Label = $ScoreLabel
@onready var multiplier_time: ProgressBar = $MultiplierTime
@onready var multiplier: Label = $MultiplierTime/Multiplier
@onready var multiplier_cd: Timer = $MultiplierCD
@onready var added: Label = $Added


var current_multiplier : int = 1
var current_score : int = 0

func _ready() -> void:
	multiplier_time.max_value = multiplier_cd.wait_time
	multiplier_time.value = multiplier_cd.wait_time


func _physics_process(delta: float) -> void:
	score_label.text = str("%016d" % current_score)
	if multiplier_time.visible:
		multiplier_time.value = multiplier_cd.time_left


func update_score(amount : int, from : Vector2):

	var plus_label : Label = added.duplicate()
	var final_position = Vector2(-13, -4) 
	var start_position = (Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randi_range(20, 70)) + get_local_mouse_position()
	var tween = get_tree().create_tween()
	
	plus_label.text = "+ " + str(current_multiplier * amount)
	plus_label.position = start_position
	plus_label.visible = true
	
	add_child(plus_label)
	
	tween.tween_property(plus_label, "scale", Vector2(1, 1), 0.75)
	tween.tween_property(plus_label, "position", final_position, 0.2)
	tween.tween_callback(plus_label.queue_free)
	
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
