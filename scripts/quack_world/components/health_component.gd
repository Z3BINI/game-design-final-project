extends Area2D
class_name HealthComponent

signal healed
signal took_dmg
signal died

@export var MAX_HP : float = 10

var current_hp : float

func _ready() -> void:
	current_hp = MAX_HP

func take_dmg(amount : float) -> void:
	print(self.name," took ", amount," damage!")
	current_hp -= amount
	print(self.name," has ", current_hp," hp!")
	took_dmg.emit()
	
	if current_hp <= 0:
		died.emit()

func heal(amount : float) -> void:
	current_hp += amount
	healed.emit()
	
	if current_hp > MAX_HP:
		current_hp = MAX_HP
