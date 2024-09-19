extends Marker2D
class_name SpawnComponent

var scene_to_spawn : PackedScene

@onready var on_screen_notifier = $OnScreenNotifier

@export var spawnable : bool = false

func _physics_process(delta):
	pass

func _on_on_screen_notifier_screen_entered():
	spawnable = false

func _on_on_screen_notifier_screen_exited():
	spawnable = true

func spawn(parent_group : String, difficulty : int = 0):
	var scene = scene_to_spawn.instantiate()
	var parent = get_tree().get_first_node_in_group(parent_group)
	
	if scene is Enemy:
		if difficulty <= 2:
			scene.MAX_SPEED = 150
			scene.ATTACK_CD = 1.5
			scene.change_hp(10)
		elif difficulty <= 4:
			scene.MAX_SPEED = 100
			scene.ATTACK_CD = 2
			scene.change_hp(8)
		elif difficulty <= 6:
			scene.MAX_SPEED = 75
			scene.change_hp(6)
	
	if parent_group:
		scene.global_position = global_position
		parent.add_child(scene)
	else:
		print("Something went wrong")
	
