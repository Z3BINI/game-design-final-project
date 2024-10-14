extends CharacterBody2D
class_name ColorBall

@export var game_object_data : GameObject

@export var GRAVITY : float = 250
@export var MIN_SPEED : float = 300
@export var MAX_SPEED : float = 1000
@export var SUCK_SPEED : float = 1000
@export var BOUNCE_AMOUNT : float = .25
@export var DAMPEN_AMOUNT : float = 0.9

var suck_pos : Vector2 = Vector2.ZERO
var suck_failed : bool = false
var speed_manager : float = 1

@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = game_object_data.get_my_color_texture()

func _process(delta: float) -> void:
	trajectory_line.update_trajectory(velocity, delta)

func _physics_process(delta: float) -> void:	
	if suck_pos != Vector2.ZERO:
		suck_me((suck_pos - global_position).normalized(), delta)
		move_and_slide()
	else:
		
		if(velocity.length() <= MIN_SPEED):
			speed_manager = 1
		elif(velocity.length() >= MAX_SPEED):
			speed_manager = DAMPEN_AMOUNT
			
		if (!is_on_floor()):
			velocity.y += GRAVITY * delta 
		
		var collision = move_and_collide(velocity * delta)
		if not collision: return
		
		velocity = velocity.bounce(collision.get_normal()) * speed_manager

func increase_velocity():
	velocity += velocity * BOUNCE_AMOUNT
	
func suck_me(direction : Vector2, delta : float):
	velocity += direction * SUCK_SPEED * delta

func shoot_in(from : Vector2):
	velocity += -from * 500
