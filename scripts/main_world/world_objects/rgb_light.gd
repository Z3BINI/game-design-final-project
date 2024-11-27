extends OmniLight3D

var current_color : Vector3
var goal_color : Vector3
var reached_color : bool = false

func _ready() -> void:
	current_color = get_random_color()
	goal_color = get_random_color()

func _physics_process(delta: float) -> void:
	light_color = Color(current_color.x, current_color.y, current_color.z)
	
	if reached_color == false:
		current_color = current_color.move_toward(goal_color, 0.5 * delta)
		
		if current_color == goal_color:
			reached_color = true
			
	else:
		goal_color = get_random_color()
		reached_color = false
	
func get_random_color() -> Vector3:
	return Vector3(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	
