extends CharacterBody2D
class_name PlayerQuack

@export var MAX_SPEED : float = 250
@export var ACCEL : float = 750
@export var DECEL : float = 500
@export var ROTATION_STEP : float = 0.2
@export var WEAPON_MAX_DIST : float = 85
@export var WEAPON_SIZE : float = 63

@export var bullet_scene : PackedScene
@export var explosive_egg_scene : PackedScene

var input_direction : Vector2

@onready var hand = $Hand
@onready var weapon_sprite = $Hand/Weapon

func _process(delta):
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
func _physics_process(delta):
	hand.global_position = get_weapon_position()
	weapon_sprite.look_at(get_global_mouse_position())
	
	if input_direction != Vector2.ZERO:
		rotation = lerp_angle(rotation, input_direction.angle(), ROTATION_STEP)
	
	if input_direction != Vector2.ZERO or velocity != Vector2.ZERO:
		var current_step : float = ACCEL if (input_direction != Vector2.ZERO) else DECEL
		velocity = velocity.move_toward(input_direction * MAX_SPEED, current_step * delta)
		
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	
	if event.is_action_pressed("jump"):
		drop_egg()

func drop_egg():
	var egg = explosive_egg_scene.instantiate()
	egg.global_position = global_position
	egg.rotation = rotation
	get_tree().get_first_node_in_group("projectiles").add_child(egg)
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = weapon_sprite.global_position
	bullet.look_at(get_global_mouse_position())
	
	get_tree().get_first_node_in_group("projectiles").add_child(bullet)
	

func get_weapon_position():
	var mouse_distance : float = global_position.distance_to(get_global_mouse_position()) 
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var weapon_position : Vector2
	
	if mouse_distance - WEAPON_SIZE > WEAPON_MAX_DIST:
		weapon_position = global_position + (mouse_direction * WEAPON_MAX_DIST)
	elif mouse_distance <= WEAPON_SIZE:
		weapon_position = global_position
	else:
		weapon_position = global_position + (mouse_direction * (mouse_distance - WEAPON_SIZE))
		
	return weapon_position

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
