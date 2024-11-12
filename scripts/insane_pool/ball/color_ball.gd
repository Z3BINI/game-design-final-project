extends CharacterBody2D
class_name ColorBall

@export var game_object_data : GameObject

@export var GRAVITY : float = 500
@export var SUCK_SPEED : float = 1000
@export var DAMPEN_AMOUNT : float = 0.75
@export var SHOOT_FORCE : float = 1500
@export var SHOOT_CD : float = 3

var suck_pos : Vector2 = Vector2.ZERO
var suck_failed : bool = false
var caught : bool = false
var timer : SceneTreeTimer = null

var my_points : int = 11

var canon : Canon

@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ball_shadow: Sprite2D = $BallShadow
@onready var my_points_label: Label = $MyPoints
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	$ShootTimer.max_value = SHOOT_CD
	$ShootTimer.value = SHOOT_CD
	
	canon = get_tree().get_first_node_in_group("canon")
	sprite_2d.texture = game_object_data.get_my_color_texture()

func _physics_process(delta: float) -> void:	
	if timer != null:
		$ShootTimer.value = timer.time_left
	
	if suck_pos != Vector2.ZERO:
		suck_me((suck_pos - global_position).normalized(), delta)
		move_and_slide()
	
	elif caught == true:
		
		global_position = canon.hold_my_balls.global_position
		trajectory_line.update_trajectory(canon.global_transform.x * SHOOT_FORCE, delta)
		
	else:

		if (!is_on_floor()):
			velocity.y += GRAVITY * delta 
		
		
		var collision = move_and_collide(velocity * delta)
		if not collision: return
		
		velocity = velocity.bounce(collision.get_normal()) * DAMPEN_AMOUNT

func suck_me(direction : Vector2, delta : float):
	velocity += direction * SUCK_SPEED * delta

func shoot_in(from : Vector2):
	velocity += -from * randf_range(300, 600)

func catch():
	sprite_2d.visible = false
	ball_shadow.visible = false
	my_points_label.visible = false
	
	$ShootTimer.visible = true
	
	trajectory_line.visible = true
	velocity = Vector2.ZERO
	caught = true
	
	timer = get_tree().create_timer(SHOOT_CD)
	await timer.timeout
	timer = null
	
	$ShootTimer.visible = false
	shoot()
	
func shoot():
	trajectory_line.visible = false
	sprite_2d.visible = true
	ball_shadow.visible = true
	my_points_label.visible = true
	caught = false
	
	if my_points > 2:
		my_points -= 1
	
	my_points_label.text = str(my_points)
	
	velocity = canon.global_transform.x * SHOOT_FORCE
	canon.animation_player.play("shoot")
	
	animation_player.play("reduced_points")
	
	await get_tree().create_timer(0.25).timeout # wait for ball to pass colider
	canon.has_ball = false
	
	
