extends CharacterBody3D

var PLAYER_GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()
	if not(is_on_floor()):
		fall(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fall(delta: float):
	velocity.y -= PLAYER_GRAVITY * delta
