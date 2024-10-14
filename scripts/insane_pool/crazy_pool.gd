extends Node2D

signal stage_cleared

var switch_scene : PackedScene = preload("res://scenes/insane_pool/switches/switch.tscn")
var ball_scene : PackedScene = preload("res://scenes/insane_pool/balls/color_ball.tscn")
var hole_scene : PackedScene = preload("res://scenes/insane_pool/holes/hole.tscn")

@onready var stage_timer: Timer = $StageTimer
@onready var holes: Node2D = $Holes
@onready var balls: Node = $Balls
@onready var switches: Node2D = $Switches
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var stage_started : bool = false
var stage_game_objects : Array

func _ready() -> void:
	test_level()
	
func _process(delta: float) -> void:
	if stage_started and balls.get_child_count() <= 0:
		stage_started=false
		stage_cleared.emit()

func test_level():
	var rand_color : GameObject.Colors = GameObject.Colors.values().pick_random()
	
	await get_tree().create_timer(2).timeout
	spawn_hole(rand_color)
	
	await get_tree().create_timer(2).timeout
	spawn_switch(rand_color)
	
	await get_tree().create_timer(2).timeout
	spawn_ball(rand_color)
	
	await get_tree().create_timer(1.5).timeout
	
	stage_started = true

func spawn_ball(color: GameObject.Colors):
	var color_ball: ColorBall = ball_scene.instantiate()
	
	color_ball.game_object_data.my_color = color
	
	var coin_toss: int = randi_range(0, 1)
	
	if (coin_toss):
		animation_player.play("spawn_right")
		await animation_player.animation_finished
	else:
		animation_player.play("spawn_left")
		await animation_player.animation_finished
		
	color_ball.position = $BallSpawner.global_position
	balls.add_child(color_ball)
	
	if (coin_toss):
		color_ball.shoot_in(Vector2.RIGHT)
		animation_player.play("spawn_right_leave")
	else:
		color_ball.shoot_in(Vector2.LEFT)
		animation_player.play("spawn_left_leave")
	
func spawn_switch(color: GameObject.Colors):
	var switch = switch_scene.instantiate()
	
	switch.game_object_data.my_color = color
	
	var switch_spawn : Marker2D = get_random_childless_node(switches.get_children())
		
	switch_spawn.add_child(switch)
	stage_game_objects.append(switch)
	
func spawn_hole(color: GameObject.Colors):
	var hole = hole_scene.instantiate()
	
	hole.game_object_data.my_color = color
	
	var hole_spawn : Marker2D = get_random_childless_node(holes.get_children())
		
	hole_spawn.add_child(hole)
	stage_game_objects.append(hole)
	

func get_random_childless_node(spawn_nodes : Array[Node]) -> Marker2D:
	var spawn : Marker2D = spawn_nodes.pick_random()
	while (spawn.get_child_count() > 0):
		spawn = spawn_nodes.pick_random()
	return spawn

func clear_stage():
	for object in stage_game_objects:
		object.queue_free()
	stage_game_objects.clear()

func _on_stage_cleared() -> void:
	clear_stage()
	test_level()
