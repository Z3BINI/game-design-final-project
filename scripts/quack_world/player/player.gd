extends CharacterBody2D
class_name PlayerQuack

@export var MAX_SPEED : float = 250
@export var ACCEL : float = 750
@export var DECEL : float = 500

var input_direction : Vector2

func _process(delta):
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
func _physics_process(delta):
	
	var current_step : float = ACCEL if (input_direction != Vector2.ZERO) else DECEL
	velocity = velocity.move_toward(input_direction * MAX_SPEED, current_step * delta)
	
	move_and_slide()
