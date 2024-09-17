extends CharacterBody2D
class_name Enemy

@export var MAX_SPEED : float = 50
@export var ACCEL : float = 500
@export var DECEL : float = 100
@export var ATTACK_DISTANCE : float = 155

@onready var navigation_agent_2d = $NavigationAgent2D

enum state {CHASE, ATTACK, DIE}

var current_state : state = state.CHASE
var player : PlayerQuack

func _ready():	
	player = get_tree().get_first_node_in_group("player")
	navigation_agent_2d.target_desired_distance = ATTACK_DISTANCE
	set_physics_process(false)
	call_deferred("dump_first_physics_frame")

func _physics_process(delta):
	
	match current_state:
		state.CHASE:
			navigation_agent_2d.target_position = player.global_position
			var direction : Vector2 = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCEL * delta)
		state.ATTACK:
			if velocity != Vector2.ZERO:
				velocity = velocity.move_toward(Vector2.ZERO, DECEL * delta)
			var player_dist : float = (player.global_position - global_position).length()
			if player_dist > ATTACK_DISTANCE:
				current_state = state.CHASE
	look_at(player.global_position)
	move_and_slide()

func _on_navigation_agent_2d_target_reached():
	current_state = state.ATTACK

func dump_first_physics_frame() -> void:
	#wait until just before the second physics_frame is ready to go, then
	#re-enable _physics_process()
	await get_tree().physics_frame
	set_physics_process(true)
