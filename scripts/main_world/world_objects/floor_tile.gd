extends StaticBody3D

var rotations : Array[int] = [0, 90, -90, 180]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate_object_local(Vector3.UP, deg_to_rad(rotations.pick_random()))
