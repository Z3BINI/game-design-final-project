extends Node2D

@export var bullet_scene : PackedScene
@export var SHOOT_CD : float = 1.5
@export var DAMAGE: float = 0.1

var possible_targets : Array[Enemy]
var shoot_cd : bool = false

@onready var shot_spawn : Marker2D = $ShotSpawn

func _physics_process(delta: float) -> void:
	if !possible_targets.is_empty():
		look_at(possible_targets[0].global_position)
		if !shoot_cd:
			shoot()
			shoot_cd = true

func _on_enemy_detector_body_entered(body: Enemy) -> void:
	possible_targets.append(body)


func _on_enemy_detector_body_exited(body: Enemy) -> void:
	possible_targets.erase(body)

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = shot_spawn.global_position
	bullet.look_at(possible_targets[0].global_position)
	bullet.change_dmg(DAMAGE)
	
	get_tree().get_first_node_in_group("projectiles").add_child(bullet)
	
	
	await get_tree().create_timer(SHOOT_CD).timeout
	
	shoot_cd = false
