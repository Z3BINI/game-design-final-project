extends TextureRect
class_name CardUpgrade

signal choice_done(id : int)

@export var one_time_use : bool = false
@export var id : int = 0
@export var needs_egg : bool = false
@export var needs_duck : bool = false

@onready var border : Sprite2D = $Border

var player : PlayerQuack

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if border.visible:
		if Input.is_action_just_pressed("shoot"):
			use()

func _on_mouse_entered():
	scale = Vector2(1.65, 1.65) 
	border.visible = true

func _on_mouse_exited():
	scale = Vector2(1.5, 1.5)
	border.visible = false

func use():
	pass
