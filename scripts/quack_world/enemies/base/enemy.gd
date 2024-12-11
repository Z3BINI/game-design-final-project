extends CharacterBody2D
class_name Enemy

@export var pain1_sfx : AudioStream
@export var pain2_sfx : AudioStream
@export var pain3_sfx : AudioStream
@export var pain4_sfx : AudioStream
@export var blood_splatter_sfx : AudioStream

@export var ACCEL : float = 300
@export var DECEL : float = 100
@export var ATTACK_DISTANCE : float = 170
@export var kill_pointer : PackedScene

var BASE_MAX_SPEED : float = 50
var BASE_ATTACK_CD : float = 3
var BASE_DMG : float = 1
var BASE_HP : float = 4

var current_multiplyer : float = 1

var score : Score

@onready var navigation_agent_2d : NavigationAgent2D = $NavigationAgent2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var health_component : HealthComponent = $HealthComponent
@onready var damage_component : DamageComponent = $DamageComponent
@onready var dmg_indicator = $DmgIndicator
@onready var damage_label = $DamageLabel
@onready var pain_sfx_arr : Array[AudioStream] = [pain1_sfx, pain2_sfx, pain3_sfx, pain4_sfx]

enum state {CHASE, ATTACK, KNOCK_BACK}

var current_state : state = state.CHASE
var player : PlayerQuack
var cd_counter : float 
var my_pointer : Node2D
var dead : bool = false

var skrrttt : bool = true

func _ready():	
	player = get_tree().get_first_node_in_group("player")
	score = get_tree().get_first_node_in_group("score")
	navigation_agent_2d.target_desired_distance = ATTACK_DISTANCE
	
	spawn_pointer()
	set_damage()
	set_hp()
	
	await get_tree().create_timer(1).timeout
	skrrttt = false

func _physics_process(delta):
	if !skrrttt:
		if !dead:
			match current_state:
				state.CHASE:
					navigation_agent_2d.target_position = player.global_position
					var direction : Vector2 = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
					velocity = velocity.move_toward(direction * BASE_MAX_SPEED * current_multiplyer, ACCEL * delta)
					look_at(player.global_position)
				state.ATTACK:
					if !player.disable_player:
						look_at(player.global_position)
						if velocity != Vector2.ZERO:
							velocity = velocity.move_toward(Vector2.ZERO, DECEL * delta)
						var player_dist : float = (player.global_position - global_position).length()
						cd_counter -= delta
						
						if cd_counter <= 0:
							cd_counter = BASE_ATTACK_CD / current_multiplyer
							animation_player.play("attack")
						
						if player_dist > ATTACK_DISTANCE:
							current_state = state.CHASE
							animation_player.play("chase")
				
		move_and_slide()

func _on_navigation_agent_2d_target_reached():
	if !dead:
		current_state = state.ATTACK
		if cd_counter == BASE_ATTACK_CD / current_multiplyer:
			animation_player.play("attack")

func _on_health_component_died() -> void:
	dead = true
	score.update_score(10, global_position)
	animation_player.play("dead")
	await animation_player.animation_finished
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

func set_damage():
	damage_component.damage_amount = BASE_DMG * current_multiplyer

func set_hp():
	health_component.MAX_HP = BASE_HP * current_multiplyer
	health_component.current_hp = health_component.MAX_HP
	health_component.set_bar()
	
func knock_back(dir : Vector2, str : float):
	current_state = state.KNOCK_BACK
	velocity = Vector2.ZERO
	velocity = dir * (str * 200 / 3)
	await get_tree().create_timer(.1).timeout
	current_state = state.CHASE

func _on_health_component_took_dmg(amount : float):
	SfxHandler.play_sfx(blood_splatter_sfx, self, 15)
	SfxHandler.play_sfx(pain_sfx_arr.pick_random(), self, 15)
	animation_player.play("take_dmg")
	damage_label.text = "-" + str(round(amount * 100) / 100.0)
	dmg_indicator.play("pull_up_dmg")
	await animation_player.animation_finished
	if !dead:
		animation_player.play("chase")
