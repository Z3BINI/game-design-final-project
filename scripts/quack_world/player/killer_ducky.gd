extends Node2D
class_name KillerDucky

@export var shot_sfx : AudioStream

@export var bullet_scene : PackedScene
@export var BASE_SHOOT_CD : float = 2.5
@export var BASE_DAMAGE: float = 0.2

var possible_targets : Array[Enemy]
var shoot_cd : bool = false
var projectiles : Node

var current_damage : float
var current_shoot_cd : float

@onready var shot_spawn : Marker2D = $ShotSpawn
@onready var shot_smoke : GPUParticles2D = $ShotSmoke


func _ready():
	current_damage = BASE_DAMAGE
	current_shoot_cd = BASE_SHOOT_CD
	
	projectiles = get_tree().get_first_node_in_group("projectiles")

func _physics_process(delta: float) -> void:
	if !possible_targets.is_empty():
		look_at(possible_targets[0].global_position)
		if !possible_targets[0].dead:
			if !shoot_cd:
				shoot()
				shoot_cd = true
		else:
			possible_targets.pop_front()
			
func _on_enemy_detector_body_entered(body: Enemy) -> void:
	possible_targets.append(body)

func _on_enemy_detector_body_exited(body: Enemy) -> void:
	possible_targets.erase(body)

func shoot():
	var bullet : Bullet = bullet_scene.instantiate()
	
	bullet.global_position = shot_spawn.global_position
	bullet.look_at(possible_targets[0].global_position)
	
	SfxHandler.play_sfx(shot_sfx, self, 0)
	projectiles.add_child(bullet)
	
	shot_smoke.emitting = true
	
	bullet.set_damage(current_damage)
	
	await get_tree().create_timer(current_shoot_cd).timeout
	
	shoot_cd = false
