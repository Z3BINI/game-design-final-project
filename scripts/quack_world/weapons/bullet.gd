extends RigidBody2D

@export var SELF_DESTROY_TIME : float = 2.5

func _ready():
	apply_central_impulse(transform.basis_xform(Vector2.RIGHT) * 15000)
	await get_tree().create_timer(SELF_DESTROY_TIME).timeout
	queue_free()
	
func _physics_process(delta):
	if get_contact_count() > 0:
		queue_free()
