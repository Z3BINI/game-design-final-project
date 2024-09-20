extends Marker2D
class_name SpawnComponent

@export var is_off_screen : bool = false

var basic_enemy_scene : PackedScene = load("res://scenes/quack_world/enemies/basic_enemy.tscn")
var bird_cage_scene : PackedScene = load("res://scenes/quack_world/components/ducky_cage.tscn")
var spawn_parent : Node 

@onready var on_screen_notifier : VisibleOnScreenNotifier2D = $OnScreenNotifier

func _ready():
	spawn_parent = get_tree().get_first_node_in_group("game_clutter")

func _on_on_screen_notifier_screen_entered():
	is_off_screen = false

func _on_on_screen_notifier_screen_exited():
	is_off_screen = true

func spawn(difficulty_multiplyer : float = -1):
	if difficulty_multiplyer > 0:
		var enemy : Enemy = basic_enemy_scene.instantiate()
		
		enemy.current_multiplyer = difficulty_multiplyer
		
		enemy.global_position = global_position
		
		spawn_parent.add_child(enemy)
		
	else:
		
		var duck_cage = bird_cage_scene.instantiate()
		
		duck_cage.global_position = global_position
		
		spawn_parent.add_child(duck_cage)
