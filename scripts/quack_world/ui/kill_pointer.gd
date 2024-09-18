extends Node2D

var target : Enemy

func _physics_process(delta):
	look_at(target.global_position)
