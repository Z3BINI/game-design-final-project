extends Control

var card_array : Array[CardUpgrade]

@onready var card_holder_1 : Control = $Card1
@onready var card_holder_2 : Control = $Card2
@onready var card_animations : AnimationPlayer = $card_animations

var game_scene : Node2D
var player : PlayerQuack

func _ready():
	load_cards_to_array("res://scenes/quack_world/ui/cards/cards/")
	
	game_scene = get_tree().get_first_node_in_group("game")
	player = get_tree().get_first_node_in_group("player")
	
func load_two_random():
	var rand_indx_1 : int = randi_range(0, card_array.size() - 1)
	var rand_indx_2 : int = randi_range(0, card_array.size() - 1)
	
	while (rand_indx_2 == rand_indx_1):
		rand_indx_2 = randi_range(0, card_array.size() - 1)
	
	var optn_1 : CardUpgrade = card_array[rand_indx_1].duplicate()
	var optn_2 : CardUpgrade = card_array[rand_indx_2].duplicate()

	optn_1.choice_done.connect(_on_card_upgrade_choice_done)
	optn_2.choice_done.connect(_on_card_upgrade_choice_done)
	
	card_holder_1.add_child(optn_1)
	card_holder_2.add_child(optn_2)

func show_cards():
	player.disable_player = true
	game_scene.toggle_pause(true)
	
	load_two_random()
	card_animations.play("show")

func _on_card_upgrade_choice_done(used_card_id : int):
	card_animations.play("chose")
	
	game_scene.toggle_pause(false)
	player.disable_player = false
	
	card_holder_1.get_child(0).queue_free()
	card_holder_2.get_child(0).queue_free()
	
	remove_if_single_use(used_card_id)


func remove_if_single_use(used_card_id : int):
	for index in range(card_array.size()):
		if card_array[index].id == used_card_id:
			if card_array[index].one_time_use:
				card_array.remove_at(index)

func load_cards_to_array(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				var card_scene : PackedScene = load(path + "/" + file_name )
				var card_obj : CardUpgrade = card_scene.instantiate()
				card_array.append(card_obj)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
