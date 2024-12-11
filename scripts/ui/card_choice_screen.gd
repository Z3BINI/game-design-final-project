extends Control

@export var card_hover_sfx : AudioStream
@export var card_use_sfx : AudioStream

var base_card_array : Array[CardUpgrade]
var egg_card_array : Array[CardUpgrade]
var duck_card_array : Array[CardUpgrade]

@onready var card_holder_1 : Control = $Card1
@onready var card_holder_2 : Control = $Card2
@onready var card_holder_3 : Control = $Card3

@onready var card_animations : AnimationPlayer = $card_animations

var game_scene : Node2D
var player : PlayerQuack
var stats : Stats

func _ready():
	load_cards_to_array("res://scenes/quack_world/ui/cards/cards/")
	
	game_scene = get_tree().get_first_node_in_group("game")
	player = get_tree().get_first_node_in_group("player")
	stats = get_tree().get_first_node_in_group("stats")
	
	
	player.learned_duck.connect(player_learned_duck)
	
func load_three_random():
	var numbers : Array[int]
	
	for i in range(base_card_array.size()):
		numbers.append(i)
	
	
	
	var index_1 : int = numbers.pick_random()
	numbers.erase(index_1)
	
	var index_2 : int = numbers.pick_random()
	numbers.erase(index_2)
	
	var index_3 : int = numbers.pick_random()
	numbers.erase(index_3)
	
	var optn_1 : CardUpgrade = base_card_array[index_1].duplicate()
	var optn_2 : CardUpgrade = base_card_array[index_2].duplicate()
	var optn_3 : CardUpgrade = base_card_array[index_3].duplicate()

	optn_1.choice_done.connect(_on_card_upgrade_choice_done)
	optn_2.choice_done.connect(_on_card_upgrade_choice_done)
	optn_3.choice_done.connect(_on_card_upgrade_choice_done)
	
	card_holder_1.add_child(optn_1)
	card_holder_2.add_child(optn_2)
	card_holder_3.add_child(optn_3)

func show_cards():
	player.disable_player = true
	game_scene.toggle_pause(true)
	
	load_three_random()
	card_animations.play("show")

func _on_card_upgrade_choice_done(used_card_id : int):
	card_animations.play("chose")
	SfxHandler.play_sfx(card_use_sfx, self, 5)
	
	game_scene.toggle_pause(false)
	player.disable_player = false
	
	card_holder_1.get_child(0).queue_free()
	card_holder_2.get_child(0).queue_free()
	
	remove_if_single_use(used_card_id)
	
	if player.unlocked_egg and !egg_card_array.is_empty():
		base_card_array.append_array(egg_card_array)
		egg_card_array.clear()
		
	stats.update_all()


func remove_if_single_use(used_card_id : int):
	for index in range(base_card_array.size()):
		if base_card_array[index].id == used_card_id:
			if base_card_array[index].one_time_use:
				base_card_array.remove_at(index)
				return

func load_cards_to_array(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print(path + file_name.get_slice(".", 0) + ".tscn")
				var card_scene : PackedScene = load(path + file_name.get_slice(".", 0) + ".tscn")
				var card_obj : CardUpgrade = card_scene.instantiate()
				if card_obj.needs_egg:
					egg_card_array.append(card_obj)
				elif card_obj.needs_duck:
					duck_card_array.append(card_obj)
				else:
					base_card_array.append(card_obj)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func player_learned_duck():
	base_card_array.append_array(duck_card_array)
	
func play_sfx_hover():
	SfxHandler.play_sfx(card_hover_sfx, self, 20)
	
