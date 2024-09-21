extends Node2D

signal game_over

@export var BASE_ENEMY_SPAWN_CD : float = 10
@export var DUCK_CAGE_SPAWN_CD : float = 60

var spawn_points : Array[Node]
var player : PlayerQuack
var current_difficulty : float = 1

@onready var spawn_points_node = $SpawnPoints
@onready var enemy_spawn : Timer = $EnemySpawn
@onready var duck : Timer = $Duck
@onready var difficulty : Timer = $Difficulty
@onready var ui = $UI

func _ready():
	spawn_points = spawn_points_node.get_children()
	player = get_tree().get_first_node_in_group("player")
	
	spawn_enemy()
	enemy_spawn.wait_time = BASE_ENEMY_SPAWN_CD
	enemy_spawn.start()
	toggle_pause(false)

func spawn_enemy():
	var off_screen_spawn_point : SpawnComponent = get_valid_spawn_points().pick_random()
	if off_screen_spawn_point:
		off_screen_spawn_point.spawn(current_difficulty)
		
	enemy_spawn.wait_time = BASE_ENEMY_SPAWN_CD / current_difficulty

func _on_player_player_died():
	game_over.emit()

func spawn_ducky_cage():
	var off_screen_spawn_point : SpawnComponent = get_valid_spawn_points().pick_random()
	if off_screen_spawn_point:
		off_screen_spawn_point.spawn()
	
	if player.ducks + 1 == 4:
		duck.stop()

func _on_enemy_spawn_timeout():
	spawn_enemy()

func _on_difficulty_timeout():
	current_difficulty += 0.2
	ui.card_choice_screen.show_cards()
	
func _on_duck_timeout():
	spawn_ducky_cage()
	
func get_valid_spawn_points() -> Array[SpawnComponent]:
	var spawnable_arr : Array[SpawnComponent]
	
	for spawn_point : SpawnComponent in spawn_points:
		if spawn_point.is_off_screen:
			spawnable_arr.append(spawn_point)
	
	return spawnable_arr

func toggle_pause(flag : bool):
	get_tree().paused = flag
