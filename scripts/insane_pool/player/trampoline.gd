extends StaticBody2D
class_name Canon

@export var ball_in_sfx : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hold_my_balls: Marker2D = $HoldMyBalls

var has_ball : bool = false

func _on_ball_detector_body_entered(body: ColorBall) -> void:
	if (body is ColorBall and !has_ball):
		has_ball = true
		SfxHandler.play_sfx(ball_in_sfx, self, 0)
		body.catch()
