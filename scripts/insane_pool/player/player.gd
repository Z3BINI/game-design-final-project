extends CharacterBody2D
class_name PoolPlayer

@export var move_speed : float = 300
@export var rotation_amount : float = 150

@onready var arms_pivot: Node2D = $ArmsPivot

var x_input_direction : float

func _process(delta: float) -> void:
	#arms_pivot.look_at(get_global_mouse_position())
	x_input_direction = Input.get_axis("move_left", "move_right")
	
	if (Input.is_action_pressed("ui_right") and arms_pivot.rotation_degrees < 0):
		arms_pivot.rotation_degrees += rotation_amount * delta
	if (Input.is_action_pressed("ui_left") and arms_pivot.rotation_degrees > -180):
		arms_pivot.rotation_degrees -= rotation_amount * delta
	
func _physics_process(delta: float) -> void:
	if x_input_direction != 0:
		velocity.x = x_input_direction * move_speed 
	else:
		velocity.x = 0
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	pass
