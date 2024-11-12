extends Node2D
class_name Hole

signal ate_ball(points, point_pos, color)

@export var game_object_data : GameObject

@onready var suckage_detector: Area2D = $SuckageDetector
@onready var hole_detector: Area2D = $HoleDetector
@onready var suck_effect_r: GPUParticles2D = $SuckEffectR
@onready var suck_effect_l: GPUParticles2D = $SuckEffectL
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = game_object_data.get_my_color_texture()

func toggle_on_off()->void:
	sprite_2d.frame = 1 if (sprite_2d.frame == 0) else 0
	suckage_detector.set_deferred("monitoring", !suck_effect_r.emitting)
	hole_detector.set_deferred("monitoring", !suck_effect_r.emitting)
	suck_effect_r.emitting = !suck_effect_r.emitting
	suck_effect_l.emitting = !suck_effect_l.emitting

func _on_suckage_detector_body_entered(body: ColorBall) -> void:
	if (body.game_object_data.my_color == game_object_data.my_color):
		body.velocity.x = 0  # Stops the ball's horizontal movement to help player on right ball
	body.suck_pos = global_position # Setting this will start suck_me() within ball
	body.trajectory_line.visible = false

func _on_suckage_detector_body_exited(body: ColorBall) -> void:
	body.suck_pos = Vector2.ZERO
	body.trajectory_line.visible = true

func _on_hole_detector_body_entered(body: ColorBall) -> void:
	if body.game_object_data.my_color != game_object_data.my_color:
		body.my_points -= 1
		
	body.queue_free()
	ate_ball.emit(body.my_points, global_position, game_object_data.my_color) 
