extends Area2D
class_name DamageComponent

@export var DMG_AMOUNT : float = 2
@export var can_dmg_player : bool = false

func _on_area_entered(area : HealthComponent) -> void:
	if ((area.get_parent().is_in_group("player") and get_parent().is_in_group("player")) or 
	(area.get_parent().is_in_group("enemy") and get_parent().is_in_group("enemy"))):
		return	
	area.take_dmg(DMG_AMOUNT)
