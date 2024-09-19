extends Area2D
class_name HealthComponent

signal healed
signal took_dmg
signal died

@export var MAX_HP : float = 10
@export var health_bar : TextureProgressBar

var current_hp : float

func _ready() -> void:
	if get_parent() is PlayerQuack:
		health_bar = get_tree().get_first_node_in_group("ui").player_hp
	
	current_hp = MAX_HP
	set_bar()

func take_dmg(amount : float) -> void:
	print(self.name," took ", amount," damage!")
	current_hp -= amount
	health_bar.value = current_hp
	print(self.name," has ", current_hp," hp!")
	took_dmg.emit()
	
	if current_hp <= 0:
		died.emit()

func heal(amount : float) -> void:
	current_hp += amount
	healed.emit()
	health_bar.value = current_hp
	
	if current_hp > MAX_HP:
		current_hp = MAX_HP

func set_bar():
	health_bar.max_value = MAX_HP
	health_bar.value = current_hp
