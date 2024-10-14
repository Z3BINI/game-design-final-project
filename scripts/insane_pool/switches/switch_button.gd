extends RigidBody2D

func _init() -> void:
	position = Vector2(randi_range(- 50, 50), randi_range(100, 400))
