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

func apply_effect(effect_list, originmodule): # Recieves a list of lists, like [["hp", -20], ["mp", 10]], and another optional statsmodule for calculating final effects.
	for e in effect_list:
		if get(e[0]) or get(e[0]) == 0:   # check if attribute exists
			set(e[0], get(e[0]) + e[1])
		else:
			print("StatsModule does not recognize that attribute: ", e[0])
