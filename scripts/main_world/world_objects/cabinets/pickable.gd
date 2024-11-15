extends RigidBody3D

var player_hold_node : Marker3D = null
var is_picked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact") and player_hold_node != null and !is_picked):
		global_position = player_hold_node.position
	elif (Input.is_action_just_pressed("interact") and is_picked):
		player_hold_node = null
		is_picked = false
		apply_central_impulse(Vector3.FORWARD * 100)


func _on_player_near_body_entered(body: Player3d) -> void:
	player_hold_node = body.hold_position

func _on_player_near_body_exited(body: Player3d) -> void:
	player_hold_node = null
