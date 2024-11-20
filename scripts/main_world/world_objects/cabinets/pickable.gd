extends RigidBody3D

signal pick_up
signal drop

var player_hold_node : Marker3D = null # Acts as player nearby bool as well
var original_parent_node : Node3D
var is_picked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_parent_node = get_parent()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		if (player_hold_node != null and !is_picked):
			is_picked = true
			pick_up.emit()
		else:
			is_picked = false
			drop.emit()
	
func _on_player_near_body_entered(body: Player3d) -> void:
	player_hold_node = body.hold_position

func _on_player_near_body_exited(body: Player3d) -> void:
	player_hold_node = null
	drop.emit() # Drop in case player buggs the item out
	
func _on_pick_up() -> void:
	gravity_scale = 0
	global_position = player_hold_node.global_position
	reparent(player_hold_node)

func _on_drop() -> void:
	gravity_scale = 1
	reparent(original_parent_node)
