extends RigidBody3D

@export var thrusters_max_strength : float = 100
@export var max_altitude : float = 5
@export var rotation_speed : float = 50
@export var max_rotate_angle : float = 45

var thrusters_min_strength : float = 50
var current_thrusters_strength : float
var input_direction : Vector2

func _physics_process(delta: float) -> void:
	current_thrusters_strength = get_interpolation_strength_ground_dist()
	if (Input.is_action_pressed("jump")): thrusters()
	get_input_direction()
	
	if input_direction != Vector2.ZERO:
		rotate_body(delta)
	else:  # It's never really 0 :(
		if (rotation_degrees.x > 1 or 
		rotation_degrees.x < -1 or 
		rotation_degrees.z > 1 or 
		rotation_degrees.z < -1):
			straighten_body(delta)
	
func thrusters(): apply_central_force(transform.basis.y * current_thrusters_strength)	
func get_input_direction(): input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func rotate_body(delta : float):
	rotation_degrees.x += input_direction.y * rotation_speed * delta
	rotation_degrees.z += -input_direction.x * rotation_speed * delta
	
func straighten_body(delta : float):
	rotation_degrees.x = move_toward(rotation_degrees.x, 0, delta * rotation_speed / 2)
	rotation_degrees.z = move_toward(rotation_degrees.z, 0, delta * rotation_speed / 2)
	
func get_interpolation_strength_ground_dist() -> float:  # Further from ground less strength
	return thrusters_max_strength - (thrusters_max_strength - thrusters_min_strength) / (max_altitude) * global_position.y
