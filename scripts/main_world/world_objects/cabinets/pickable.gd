extends RigidBody3D

var can_be_picked : bool = false
var is_picked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact") and can_be_picked and !is_picked):
		pass # Pick up


func _on_player_near_body_entered(body: Player3d) -> void:
	can_be_picked = true


func _on_player_near_body_exited(body: Player3d) -> void:
	can_be_picked = true
