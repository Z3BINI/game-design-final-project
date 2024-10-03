extends Control
class_name Score

@export var multiplier_max : int = 10

@onready var score_label: Label = $ScoreLabel
@onready var multiplier_time: ProgressBar = $MultiplierTime
@onready var multiplier: Label = $MultiplierTime/Multiplier
@onready var multiplier_cd: Timer = $MultiplierCD
@onready var added: Label = $Added
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var current_multiplier : int = 1
var current_score : int = 0

func _ready() -> void:
	multiplier_time.max_value = multiplier_cd.wait_time
	multiplier_time.value = multiplier_cd.wait_time


func _physics_process(delta: float) -> void:
	score_label.text = str("%016d" % current_score)
	if multiplier_time.visible:
		multiplier_time.value = multiplier_cd.time_left


func update_score(amount : int):
	added.text = "+ " + str(current_multiplier * amount)
	
	var animation = animation_player.get_animation("add_points")
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	var final_position = Vector2(-13, -4) 
	var start_position = get_local_mouse_position()
	
	animation.track_set_path(track_index, "Added:position")
	animation.track_insert_key(track_index, 0.0, start_position)
	animation.track_insert_key(track_index, 0.4, start_position)
	animation.track_insert_key(track_index, 0.5, final_position)
	
	animation_player.play("add_points")
	await animation_player.animation_finished
	
	animation.remove_track(track_index)
	
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
