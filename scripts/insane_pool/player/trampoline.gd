extends StaticBody2D
class_name Canon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hold_my_balls: Marker2D = $HoldMyBalls

var has_ball : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ball_detector_body_entered(body: ColorBall) -> void:
	if (body is ColorBall and !has_ball):
		has_ball = true
		body.catch()
