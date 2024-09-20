extends Node2D

@export var pointer : PackedScene
@export var release_time : float = 5

var player : PlayerQuack
var my_pointer
var player_near : bool = false
var player_can_release : bool = false
var release_progress : float = 0

@onready var ducky_pivot = $DuckyPivot
@onready var release_progress_bar = $DuckyPivot/ReleaseProgress


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	release_progress_bar.max_value = release_time
	player = get_tree().get_first_node_in_group("player")
	spawn_pointer()

func _physics_process(delta):
	if player_near:
		ducky_pivot.look_at(player.global_position)
	
	release_progress_bar.value = release_progress
	release_progress_bar.visible = (release_progress > 0)
	
	if Input.is_action_pressed("interact") and player_can_release:
		release_progress += delta
		
		if !player.disable_player:
			player.disable_player = true
		
		if release_progress >= release_time:
			release_ducky()
			player.disable_player = false
			
	else:
		if player.disable_player:
			player.disable_player = false
			
		if release_progress > 0:
			release_progress -= delta

func _on_player_detector_body_entered(body: PlayerQuack) -> void:
	player_can_release = true

func _on_player_detector_body_exited(body):
	player_can_release = false
	
func spawn_pointer():
	my_pointer = pointer.instantiate()
	my_pointer.target = self
	
	player.add_child(my_pointer)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	my_pointer.visible = false
	player_near = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	my_pointer.visible = true
	player_near = false

func release_ducky():
	player.enable_ducky(player.ducks)
	player.ducks += 1
	my_pointer.queue_free()
	queue_free()
