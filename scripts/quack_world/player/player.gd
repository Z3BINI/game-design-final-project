extends CharacterBody2D
class_name PlayerQuack

signal learned_duck
signal player_died
signal player_damaged

@export var BASE_MAX_SPEED : float = 150
@export var BASE_BASIC_DAMAGE : float = 1
@export var BASE_EGG_DAMAGE : float = 2
@export var BASE_BASIC_CD : float = 1.5
@export var BASE_EGG_CD : float = 4


@export var ACCEL : float = 750
@export var DECEL : float = 500
@export var ROTATION_STEP : float = 0.2
@export var WEAPON_MAX_DIST : float = 85
@export var WEAPON_SIZE : float = 63

@export var bullet_scene : PackedScene
@export var explosive_egg_scene : PackedScene

var input_direction : Vector2
var disable_player : bool = false
var ducks : int = 0
var shoot_cd : bool = false
var egg_cd : bool = false
@export var unlocked_egg : bool = false

var killer_duckies : Array[KillerDucky]

var current_max_hp : float
var current_max_speed : float
var current_basic_dmg : float
var current_egg_dmg : float
var current_basic_cd : float
var current_egg_cd : float
var stats : Stats
var projectile_holder : Node

var duck_arr : Array

@onready var hand = $Hand
@onready var weapon_sprite = $Hand/Weapon
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var gun_anim = $GunAnim
@onready var ducky_positions: Node2D = $DuckyPositions


func _ready():
	projectile_holder = get_tree().get_first_node_in_group("projectiles")
	stats = get_tree().get_first_node_in_group("stats")
	
	current_max_speed = BASE_MAX_SPEED
	current_basic_dmg = BASE_BASIC_DAMAGE
	current_egg_dmg = BASE_EGG_DAMAGE
	current_basic_cd = BASE_BASIC_CD
	current_egg_cd = BASE_EGG_CD
	current_max_hp = health_component.MAX_HP
	
	
	
	for child in ducky_positions.get_children():
		duck_arr.append(child.get_child(0))
		
	stats.update_all()

func _process(delta):
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	for ducky in $DuckyPositions.get_children():
		killer_duckies.append(ducky.get_child(0))

func _physics_process(delta):
	if !disable_player:
		hand.global_position = get_weapon_position()
		weapon_sprite.look_at(get_global_mouse_position())
		
		if input_direction != Vector2.ZERO:
			rotation = lerp_angle(rotation, input_direction.angle(), ROTATION_STEP)
		
		if input_direction != Vector2.ZERO or velocity != Vector2.ZERO:
			var current_step : float = ACCEL if (input_direction != Vector2.ZERO) else DECEL
			velocity = velocity.move_toward(input_direction * current_max_speed, current_step * delta)
	else:
		velocity = Vector2.ZERO
				
	move_and_slide()

func _input(event):
	if !disable_player:
		if event.is_action_pressed("shoot") and !shoot_cd:
			shoot()
		
		if event.is_action_pressed("jump") and !egg_cd and unlocked_egg:
			drop_egg()

func drop_egg():
	egg_cd = true
	
	var egg : ExplosiveEgg = explosive_egg_scene.instantiate()
	
	egg.global_position = global_position
	egg.rotation = rotation
	
	projectile_holder.add_child(egg)
	
	egg.set_damage(current_egg_dmg)
	
	await get_tree().create_timer(current_egg_cd).timeout
	
	egg_cd = false
	
func shoot():
	shoot_cd = true
	
	var bullet : Bullet = bullet_scene.instantiate()
	
	bullet.global_position = weapon_sprite.global_position
	bullet.look_at(get_global_mouse_position())
	
	projectile_holder.add_child(bullet)
	
	gun_anim.play("shoot")
	
	bullet.set_damage(current_basic_dmg)
	
	await get_tree().create_timer(current_basic_cd).timeout
	
	shoot_cd = false

func get_weapon_position():
	var mouse_distance : float = global_position.distance_to(get_global_mouse_position()) 
	var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var weapon_position : Vector2
	
	if mouse_distance - WEAPON_SIZE > WEAPON_MAX_DIST:
		weapon_position = global_position + (mouse_direction * WEAPON_MAX_DIST)
	elif mouse_distance <= WEAPON_SIZE:
		weapon_position = global_position
	else:
		weapon_position = global_position + (mouse_direction * (mouse_distance - WEAPON_SIZE))
		
	return weapon_position

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func _on_health_component_took_dmg(amount : float):
	player_damaged.emit()
	animation_player.play("take_dmg")


func _on_health_component_died():
	disable_duckies()
	animation_player.play("die")
	await animation_player.animation_finished
	player_died.emit()

func _on_quack_man_world_game_over():
	hand.visible = false
	disable_player = true

func enable_ducky(number: int):
	if ducks == 1:
		learned_duck.emit()
	killer_duckies[number].visible = true
	killer_duckies[number].process_mode = Node.PROCESS_MODE_INHERIT

func disable_duckies():
	for duck in killer_duckies:
		duck.visible = false
		duck.process_mode = Node.PROCESS_MODE_DISABLED
		
func upgrade_hp():
	$HealthComponent.MAX_HP += 1
	$HealthComponent.set_bar()
	current_max_hp = $HealthComponent.MAX_HP

func replenish_hp():
	$HealthComponent.current_hp = $HealthComponent.MAX_HP
	$HealthComponent.set_bar()
	
func duck_upgrade(type : String, amount : float):
	match type:
		"shot_cd":
			for killer_duck in duck_arr:
				killer_duck.current_shoot_cd -= (killer_duck.current_shoot_cd * amount)
		"shot_dmg":
			for killer_duck in duck_arr:
				killer_duck.current_damage += (killer_duck.current_damage * amount)
