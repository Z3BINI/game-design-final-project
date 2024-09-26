extends PanelContainer
class_name EnemyStats

@onready var hp: Label = $MarginContainer/VBoxContainer/Hp
@onready var movement_speed: Label = $MarginContainer/VBoxContainer/MovementSpeed
@onready var basic_attack: Label = $MarginContainer/VBoxContainer/BasicAttack
@onready var basic_cd: Label = $MarginContainer/VBoxContainer/BasicCd

var enemy : Enemy

func update_all():
	update_hp_label()
	update_movement_label()
	update_basic_attack_label()
	update_basic_cd_label()

func update_hp_label():
	hp.text = "Max HP: " + str(enemy.health_component.MAX_HP * (enemy.current_multiplyer + 0.15))

func update_movement_label():
	movement_speed.text = "MSpeed: " + str("%1.2f" % (enemy.BASE_MAX_SPEED * (enemy.current_multiplyer + 0.15))) # +1?

func update_basic_attack_label():
	basic_attack.text = "AtkDmg: " + str("%1.2f" % (enemy.BASE_DMG * (enemy.current_multiplyer + 0.15)))
	
func update_basic_cd_label():
	basic_cd.text = "AtkCD: " + str("%1.2f" % (enemy.BASE_DMG * (enemy.current_multiplyer + 0.15)))
	
func _on_visibility_changed() -> void:
	enemy = get_tree().get_first_node_in_group("enemy")
	update_all()
