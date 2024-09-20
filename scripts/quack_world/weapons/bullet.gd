extends RigidBody2D
class_name Bullet

@export var SELF_DESTROY_TIME : float = 2.5

@onready var damage_component : DamageComponent = $DamageComponent

func _ready():
	apply_central_impulse(transform.basis_xform(Vector2.RIGHT) * 15000)
	await get_tree().create_timer(SELF_DESTROY_TIME).timeout
	queue_free()
	
func _physics_process(_delta : float):
	if get_contact_count() > 0:
		queue_free()

func set_damage(amount: float):
	damage_component.damage_amount = amount
