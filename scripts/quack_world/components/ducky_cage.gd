extends Node2D

@export var pointer : PackedScene
var player : PlayerQuack
var my_pointer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_pointer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_detector_body_entered(body: PlayerQuack) -> void:
	body.enable_ducky(body.ducks)
	body.ducks += 1
	my_pointer.queue_free()
	queue_free()


func spawn_pointer():
	my_pointer = pointer.instantiate()
	my_pointer.target = self
	
	player.add_child(my_pointer)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	my_pointer.visible = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	my_pointer.visible = true
