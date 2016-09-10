extends Node

export(int) var level = 1
export(String, "str", "int", "agi") var primary_stat = "str"
export(int) var strength = 0
export(int) var intelligence = 0
export(int) var agility = 0
export(int) var spirit = 0
export(int) var stamina = 0
export(int) var max_hp = 10
export(int) var max_mp = 5
export(float) var base_damage = 1.0
export(float) var spell_power = 0.0
export(float) var phys_crit = 0.0
export(float) var spell_crit = 0.0
export(int) var hit_rate = 0
export(int) var armor = 0
export(int) var magic_resist = 0
export(int) var movement_speed = 100
var hp = max_hp
var mp = max_mp

func _ready():
	set_process(true)

func _process(delta):
	if hp > max_hp:
		hp = max_hp
	elif hp < 0:
		hp = 0
	if mp > max_mp:
		mp = max_mp
	elif mp < 0 :
		mp = 0

func apply_effect(effectmodule, originmodule): # Recieves an EffectModule, and another optional statsmodule for calculating final effects.
	# for e in effect_list:
	# 	if get(e[0]) or get(e[0]) == 0:   # check if attribute exists
	# 		set(e[0], get(e[0]) + e[1])
	# 	else:
	# 		print("StatsModule does not recognize that attribute: ", e[0])
	if get(effectmodule.effect_stat) or get(effectmodule.effect_stat) == 0:
		# print(effectmodule.effect_stat, effectmodule.amount)
		set(effectmodule.effect_stat, get(effectmodule.effect_stat) + effectmodule.amount)
	else:
		print("StatsModule does not recognize that attribute: ", effectmodule.effect_stat)

func get_actual(stat):
	pass

# Scaling and modifier functions #

func sp_modifier():
	return spell_power + (float(intelligence) * 1.5)

func dmg_modifier():
	return base_damage + (float(strength) * 1.25)

func armor_modifier():
	return armor
