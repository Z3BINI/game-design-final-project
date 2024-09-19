extends Area2D
class_name DamageComponent

@export var DMG_AMOUNT : float = 2
@export var can_dmg_player : bool = false

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_area_entered(area : HealthComponent) -> void:
	if ((area.get_parent().is_in_group("player") and get_parent().is_in_group("player_wep")) or 
	(area.get_parent().is_in_group("enemy") and get_parent().is_in_group("enemy"))):
		return	
	area.take_dmg(DMG_AMOUNT)
	if area.get_parent() is Enemy:
		area.get_parent().knock_back((area.get_parent().global_position - player.global_position).normalized(), DMG_AMOUNT)
