extends Area2D
class_name DamageComponent

@export var DMG_AMOUNT : float = 2

func _on_area_entered(area : HealthComponent) -> void:
	print(self.name)
	area.take_dmg(DMG_AMOUNT)
