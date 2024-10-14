extends StaticBody2D

@export var game_object_data : GameObject

@onready var line_2d: Line2D = $Line2D
@onready var switch_button: RigidBody2D = $SwitchButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $SwitchButton/Sprite2D
@onready var switch_shadow: Sprite2D = $SwitchButton/SwitchShadow

var my_color_holes : Array[Hole]
var switch : bool = false
var switch_cd : bool = false
var player : PoolPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	player = get_tree().get_first_node_in_group("player")
	
	sprite_2d.texture = game_object_data.get_my_color_texture()
	line_2d.points[0] = to_local(global_position)
	
	var level_holes : Array[Node] = get_tree().get_nodes_in_group("hole")
	
	for hole_node : Hole in level_holes:
		if hole_node.game_object_data.my_color == game_object_data.my_color:
			my_color_holes.append(hole_node)

func _physics_process(delta: float) -> void:
	line_2d.points[1] = switch_button.position
	
	if player:
		point_sprites_to_player((player.global_position - global_position).normalized().x < 0)

func point_sprites_to_player(flip : bool):
	sprite_2d.flip_h = flip
	switch_shadow.flip_h = flip

func _on_switch_trigger_body_entered(body) -> void:
	if (body is ColorBall and !switch_cd):
		switch_cd = true
		
		switch = !switch
		animation_player.play("on") if switch else animation_player.play("off")
		
		for my_color_hole in my_color_holes:
			my_color_hole.toggle_on_off()
		
		await get_tree().create_timer(1).timeout
		switch_cd = false
