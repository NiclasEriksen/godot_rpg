extends Node

export(int) var level = 1
export(String, "str", "int", "agi") var primary_stat = "str"
export(int) var base_strength = 0
export(int) var base_intelligence = 0
export(int) var base_agility = 0
export(int) var base_spirit = 0
export(int) var base_stamina = 0
export(int) var max_hp = 10.0 # Replace with base
export(int) var max_mp = 5.0  # Replace with base
export(float) var base_damage = 1.0
export(float) var base_spell_power = 0.0
export(float) var base_phys_crit = 0.0
export(float) var base_spell_crit = 0.0
export(int) var base_hit_rate = 0
export(int) var base_armor = 0
export(int) var base_magic_resist = 0
export(int) var base_movement_speed = 90
export(int) var base_attack_speed = 2.0
var hp = max_hp
var mp = max_mp
var strength = base_strength
var agility = base_agility
var intelligence = base_intelligence
var spirit = base_spirit
var stamina = base_stamina
var damage = base_damage
var spell_power = base_spell_power
var phys_crit = base_phys_crit
var spell_crit = base_spell_crit
var hit_rate = base_hit_rate
var armor = base_armor
var magic_resist = base_magic_resist
var attack_speed = base_attack_speed
var immobile = false


var final_stats = {
	hp=max_hp,
	mp=max_mp,
	strength=base_strength,
	agility=base_agility,
	intelligence=base_intelligence,
	spirit=base_spirit,
	stamina=base_stamina,
	damage=base_damage,
	spell_power=base_spell_power,
	phys_crit=base_phys_crit,
	spell_crit=base_spell_crit,
	hit_rate=base_hit_rate,
	armor=base_armor,
	magic_resist=base_magic_resist,
	attack_speed=base_attack_speed,
	movement_speed=base_movement_speed,
}

var active_effects = []

#TODO
# getset functions for all stats, reroute to functions that calculate final stats
# get = final stat, set = set base stat (should not be used dynamically)
# instead of setting base stat directly, most cases should be handled by passing modifier objects
# such as stats on gear, talent traits etc.



func _ready():
	self.hp = self.max_hp
	self.mp = self.max_mp
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	if hp > max_hp:
		hp = max_hp
	if mp > max_mp:
		mp = max_mp
	check_negatives()
	for e in active_effects:
		var buff_result = [false, false]
		buff_result = e.buff_update(delta)
		if not buff_result[0]:
			if e.effect_type == "stun":
				immobile = false
			active_effects.erase(e)
			print("Removing buff.")
		elif buff_result[1]:
			print("Applying tick.")
			apply_effect(e, null)

func _fixed_process(delta):
	pass

func check_negatives():
	if hp < 0:
		hp = 0
	if mp < 0 :
		mp = 0


func apply_effect(effectmodule, originmodule): # Recieves an EffectModule, and another optional statsmodule for calculating final effects.
	if effectmodule.is_buff:
		if not effectmodule in active_effects:
			active_effects.append(effectmodule)
			print("Added buff.")
			return
	if effectmodule.effect_type == "stun":
		immobile = true
	elif get(effectmodule.effect_stat) or get(effectmodule.effect_stat) == 0:
		# print(effectmodule.effect_stat, effectmodule.amount)
		set(effectmodule.effect_stat, get(effectmodule.effect_stat) + effectmodule.amount)
	else:
		print("StatsModule does not recognize that attribute: ", effectmodule.effect_stat)

func get_actual(stat):
	if final_stats.has(stat):
		return final_stats[stat]

func get_base(stat):
	pass

# Scaling and modifier functions #

func sp_modifier():
	return spell_power + (float(intelligence) * 1.5)

func dmg_modifier():
	return base_damage + (float(strength) * 1.25)

func armor_modifier():
	return armor
