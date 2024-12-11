extends RigidBody2D
class_name ExplosiveEgg

signal egg_exploded

@export var explosion_sfx : AudioStream

var explosion_timer : float = 3
var explode_on_hit : bool = false
var explosion_timer_scale : float = 1

@onready var explosion : GPUParticles2D = $Explosion
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var damage_component = $DamageComponent


func _ready():
	var ui_node = get_tree().get_first_node_in_group("ui")
	
	connect("egg_exploded", ui_node.on_egg_explosion) 
	
	apply_central_impulse(transform.basis_xform(Vector2.LEFT) * 125)
	animation_player.speed_scale = explosion_timer_scale
	animation_player.play("detonated")
	await animation_player.animation_finished
	explode()
	
func _physics_process(delta):
	if explode_on_hit and get_contact_count() > 0:
		explode()

func explode():
	SfxHandler.play_sfx(explosion_sfx, self, 0)
	animation_player.play("explode")
	egg_exploded.emit()
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	queue_free()

func set_damage(amount: float):
	damage_component.damage_amount = amount
