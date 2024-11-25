extends CharacterBody3D
class_name  Player3d

@export var MAX_SPEED : float = 10
@export var ACCEL : float = 0.6
@export var DECEL : float = 0.25
@export var JUMP_FORCE : float = 5

@export var mouse_sens : float = 0.5

var PLAYER_GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_direction : Vector2 
var push_force = 5
var has_item : bool = false

@onready var camera_pivot = $CameraStand
@onready var hud_label = $Hud/Label
@onready var hold_position: Marker3D = $CameraStand/Camera3D/HoldPosition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
	
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
	
func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		
	if event is InputEventMouseMotion:
		rotate_pov(event.relative)
	
func movement():
	# Pick between accel or decel value depending on user input
	var current_step : float = DECEL if input_direction == Vector2.ZERO else ACCEL
	var local_direction : Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	velocity.x = move_toward(velocity.x, local_direction.x * MAX_SPEED, current_step)
	velocity.z = move_toward(velocity.z, local_direction.z * MAX_SPEED, current_step)

func fall(delta: float):
	velocity.y -= PLAYER_GRAVITY * delta

func rotate_pov(prev_mouse_pos : Vector2):
	rotate_y(deg_to_rad(-prev_mouse_pos.x * mouse_sens))
	camera_pivot.rotate_x(deg_to_rad(-prev_mouse_pos.y * mouse_sens))
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	
func toggle_hud_label(value : bool, interact_text : String = ""):
	hud_label.text = interact_text
	hud_label.visible = value
	
