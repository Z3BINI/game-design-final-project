extends Area2D
class_name DamageComponent

@export var DMG_AMOUNT : float = 2
@export var can_dmg_player : bool = false

func _on_area_entered(area : HealthComponent) -> void:
	if area.get_parent() is PlayerQuack and !can_dmg_player:
		return	
	area.take_dmg(DMG_AMOUNT)
