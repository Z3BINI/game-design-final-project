extends Line2D

@onready var trajectory_bounce_probe: CharacterBody2D = $TrajectoryBounceProbe
@onready var color_ball: ColorBall = $".."

func _ready() -> void:
	match color_ball.game_object_data.my_color:
		color_ball.game_object_data.Colors.ORANGE:
			default_color = Color.CORAL
		color_ball.game_object_data.Colors.RED:
			default_color = Color.DARK_RED
		color_ball.game_object_data.Colors.GREEN:
			default_color = Color.SEA_GREEN
		color_ball.game_object_data.Colors.BLUE:
			default_color = Color.DARK_BLUE

func update_trajectory(ball_velocity : Vector2, delta : float):
	var max_points : int = 150 if ball_velocity.length() < 1000 else 75
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	var vel = ball_velocity
	
	for i in max_points:
		add_point(pos)
		vel.y += color_ball.GRAVITY * delta
		
		var collision_probe = trajectory_bounce_probe.move_and_collide(vel * delta, false, true, true)
		if collision_probe:
			if collision_probe.get_collider() is Trampoline:
				vel += vel * color_ball.BOUNCE_AMOUNT
			vel = vel.bounce(collision_probe.get_normal()) * color_ball.speed_manager
			
		pos += vel * delta
		trajectory_bounce_probe.position = pos
