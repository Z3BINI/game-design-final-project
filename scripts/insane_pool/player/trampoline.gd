extends StaticBody2D
class_name Canon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ball_detector_body_entered(body: ColorBall) -> void:
	animation_player.play("bounce")
	if (body is ColorBall):
		#body.increase_velocity()
		body.catch()
