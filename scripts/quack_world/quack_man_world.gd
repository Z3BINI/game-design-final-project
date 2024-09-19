extends Node2D

signal game_over

@onready var spawn_points_node = $SpawnPoints

@export var ENEMY_SPAWN_CD : float = 10

@export var enemy_scene : PackedScene
@export var duck_cage : PackedScene

var spawn_points : Array
var player : PlayerQuack

func _ready():
	spawn_points = spawn_points_node.get_children()
	player = get_tree().get_first_node_in_group("player")
	spawn_enemy()
	
	await get_tree().create_timer(30).timeout
	
	increase_difficulty()
	
	await get_tree().create_timer(30).timeout
	
	spawn_ducky_cage()

func spawn_enemy():
	var enemy_spawn : SpawnComponent = get_valid_spawn_points().pick_random()
	enemy_spawn.scene_to_spawn = enemy_scene
	enemy_spawn.spawn("game_clutter", ENEMY_SPAWN_CD)
	
	await get_tree().create_timer(ENEMY_SPAWN_CD).timeout
	
	spawn_enemy()

func get_valid_spawn_points() -> Array[SpawnComponent]:
	var spawnable_arr : Array[SpawnComponent]
	
	for spawn_point : SpawnComponent in spawn_points:
		if spawn_point.spawnable:
			spawnable_arr.append(spawn_point)
	
	return spawnable_arr


func _on_player_player_died():
	game_over.emit()

func increase_difficulty():
	if ENEMY_SPAWN_CD > 2:
		ENEMY_SPAWN_CD -= 2
		
		await get_tree().create_timer(30).timeout
		
		increase_difficulty()

func spawn_ducky_cage():
	var spawn : SpawnComponent = get_valid_spawn_points().pick_random()
	spawn.scene_to_spawn = duck_cage
	spawn.spawn("game_clutter")
	
	if player.ducks < 4:
		await get_tree().create_timer(30).timeout
		
		spawn_ducky_cage()
