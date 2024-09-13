extends CharacterBody3D

@export var MAX_SPEED : float = 10
@export var ACCEL : float = 0.6
@export var DECEL : float = 0.25

var PLAYER_GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_direction : Vector2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if (input_direction != Vector2.ZERO or 
	velocity.x != 0 or 
	velocity.z != 0):
		movement()
	
	if not(is_on_floor()):
		fall(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
func movement():
	# Pick between accel or decel value depending on user input
	var current_step : float = DECEL if input_direction == Vector2.ZERO else ACCEL

	velocity.x = move_toward(velocity.x, input_direction.x * MAX_SPEED, current_step)
	velocity.z = move_toward(velocity.z, input_direction.y * MAX_SPEED, current_step)
	

func fall(delta: float):
	velocity.y -= PLAYER_GRAVITY * delta
