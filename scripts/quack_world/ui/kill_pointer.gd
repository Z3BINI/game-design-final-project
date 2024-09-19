extends Node2D

var target : Node2D

func _physics_process(delta):
	look_at(target.global_position)
