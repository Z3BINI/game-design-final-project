extends Node2D

@onready var spawn_points_node = $SpawnPoints

@export var ENEMY_SPAWN_CD : float = 10

@export var enemy_scene : PackedScene

var spawn_points : Array

func _ready():
	spawn_points = spawn_points_node.get_children()
	
	spawn_enemy()
	
	await get_tree().create_timer(15).timeout
	
	increase_difficulty()

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
	get_tree().reload_current_scene()

func increase_difficulty():
	if ENEMY_SPAWN_CD > 2:
		ENEMY_SPAWN_CD -= 2
		
		await get_tree().create_timer(10).timeout
		
		increase_difficulty()
