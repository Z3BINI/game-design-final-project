extends CharacterBody2D
class_name Enemy

@export var MAX_SPEED : float = 50
@export var ACCEL : float = 300
@export var DECEL : float = 100
@export var ATTACK_DISTANCE : float = 155
@export var ATTACK_CD : float = 2.5

@export var kill_pointer : PackedScene

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent

enum state {CHASE, ATTACK, DIE}

var current_state : state = state.CHASE
var player : PlayerQuack
var cd_counter : float = ATTACK_CD
var my_pointer : Node2D

func _ready():	
	player = get_tree().get_first_node_in_group("player")
	navigation_agent_2d.target_desired_distance = ATTACK_DISTANCE
	set_physics_process(false)
	call_deferred("dump_first_physics_frame")
	
	spawn_pointer()

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
			cd_counter -= delta
			
			if cd_counter <= 0:
				cd_counter = ATTACK_CD
				animation_player.play("attack")
			
			if player_dist > ATTACK_DISTANCE:
				current_state = state.CHASE
				animation_player.play("chase")
				
	look_at(player.global_position)
	move_and_slide()

func _on_navigation_agent_2d_target_reached():
	current_state = state.ATTACK
	if cd_counter == ATTACK_CD:
		animation_player.play("attack")

func dump_first_physics_frame() -> void:
	#wait until just before the second physics_frame is ready to go, then
	#re-enable _physics_process()
	await get_tree().physics_frame
	set_physics_process(true)

func _on_health_component_died() -> void:
	my_pointer.queue_free()
	queue_free()

func spawn_pointer():
	my_pointer = kill_pointer.instantiate()
	my_pointer.target = self
	
	player.add_child(my_pointer)

func _on_visible_on_screen_notifier_2d_screen_entered():
	my_pointer.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	my_pointer.visible = true

func change_hp(value : int):
	health_component = $HealthComponent
	health_component.MAX_HP = value
	health_component.current_hp = value
	health_component.set_bar()
