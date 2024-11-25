extends RigidBody3D

signal pick_up
signal drop

var player_hold_node : Marker3D = null # Acts as player nearby bool as well
var original_parent_node : Node3D
var is_picked : bool = false
var player : Player3d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_parent_node = get_parent()
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		if (player_hold_node != null and !is_picked):
			is_picked = true
			pick_up.emit()
		else:
			is_picked = false
			drop.emit()

func _physics_process(delta: float) -> void:
	if is_picked:
		global_position = player_hold_node.global_position
		look_at(player_hold_node.get_parent().global_position)

func _on_player_near_body_entered(body: Player3d) -> void:
	if !body.has_item:
		body.has_item = true
		player_hold_node = body.hold_position
		body.toggle_hud_label(true, "Press [E] to inspect!")

func _on_player_near_body_exited(body: Player3d) -> void:
	body.toggle_hud_label(false)
	player_hold_node = null
	
func _on_pick_up() -> void:
	player.toggle_hud_label(true, "Press [E] to drop!")
	freeze = true

func _on_drop() -> void:
	player.has_item = false
	player.toggle_hud_label(true, "Press [E] to inspect!")
	freeze = false
