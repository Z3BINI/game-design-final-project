extends PanelContainer
class_name Stats

@onready var hp: Label = $MarginContainer/VBoxContainer/Hp
@onready var movement_speed: Label = $MarginContainer/VBoxContainer/MovementSpeed
@onready var basic_attack: Label = $MarginContainer/VBoxContainer/BasicAttack
@onready var basic_cd: Label = $MarginContainer/VBoxContainer/BasicCd
@onready var egg_attack: Label = $MarginContainer/VBoxContainer/EggAttack
@onready var egg_cd: Label = $MarginContainer/VBoxContainer/EggCd
@onready var duck_attack: Label = $MarginContainer/VBoxContainer/DuckAttack
@onready var duck_cd: Label = $MarginContainer/VBoxContainer/DuckCd

var player : PlayerQuack
var ducky : KillerDucky

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	ducky = get_tree().get_first_node_in_group("ducky")

func update_all():
	update_hp_label()
	update_movement_label()
	update_basic_attack_label()
	update_basic_cd_label()
	update_egg_attack_label()
	update_egg_cd_label()
	update_duck_attack_label()
	update_duck_cd_label()

func update_hp_label():
	hp.text = "Max HP: " + str(player.current_max_hp)

func update_movement_label():
	movement_speed.text = "MSpeed: " + str("%1.2f" % player.current_max_speed)

func update_basic_attack_label():
	basic_attack.text = "AtkDmg: " + str("%1.2f" % player.current_basic_dmg)
	
func update_basic_cd_label():
	basic_cd.text = "AtkCD: " + str("%1.2f" % player.current_basic_cd)
	
func update_egg_attack_label():
	egg_attack.text = "EggDmg: " + str("%1.2f" % player.current_egg_dmg)

func update_egg_cd_label():
	egg_cd.text = "EggCD: " + str("%1.2f" % player.current_egg_cd)
	
func update_duck_attack_label():
	duck_attack.text = "DuckDmg: " + str("%1.2f" % ducky.current_damage)
	
func update_duck_cd_label():
	duck_cd.text = "DuckCD: " + str("%1.2f" % ducky.current_shoot_cd)
