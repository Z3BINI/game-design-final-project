extends RigidBody2D

@export var EXPLOSION_TIMER : float = 3

@onready var explosion = $Explosion
@onready var sprite_2d = $Sprite2D

func _ready():
	apply_central_impulse(transform.basis_xform(Vector2.LEFT) * 250)
	await get_tree().create_timer(EXPLOSION_TIMER).timeout
	explosion.emitting = true
	sprite_2d.visible = false
	await explosion.finished
	queue_free()
	
func _physics_process(delta):
	if get_contact_count() > 0:
		explosion.emitting = true
		sprite_2d.visible = false
		await explosion.finished
		queue_free()
