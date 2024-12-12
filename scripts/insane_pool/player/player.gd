extends CharacterBody2D
class_name PoolPlayer

@export var move_speed : float = 300
@export var rotation_amount : float = 150

@onready var arms_pivot: Node2D = $ArmsPivot
@onready var rotation_sfx = $Rotation
@onready var movement_sfx = $Movement

var x_input_direction : float
var playing_rotation : bool = false
var playing_movement : bool = false


func _ready() -> void:
	arms_pivot.rotation_degrees = -90 # Look up!

func _process(delta: float) -> void:
	#arms_pivot.look_at(get_global_mouse_position())
	x_input_direction = Input.get_axis("move_left", "move_right")
	
	if (Input.is_action_pressed("ui_right") and arms_pivot.rotation_degrees < 0):
		arms_pivot.rotation_degrees += rotation_amount * delta
		
		if !playing_rotation:
			playing_rotation = true
			rotation_sfx.play()
	elif (Input.is_action_pressed("ui_left") and arms_pivot.rotation_degrees > -180):
		arms_pivot.rotation_degrees -= rotation_amount * delta
		
		if !playing_rotation:
			playing_rotation = true
			rotation_sfx.play()
			
	else:
		if playing_rotation:
			playing_rotation = false
			rotation_sfx.stop()
	
func _physics_process(delta: float) -> void:
	if x_input_direction != 0:
		if !playing_movement:
			playing_movement = true
			movement_sfx.play()
			
		velocity.x = x_input_direction * move_speed 
	else:
		if playing_movement:
			playing_movement = false
			movement_sfx.stop()
			
		velocity.x = 0
		
	move_and_slide()
