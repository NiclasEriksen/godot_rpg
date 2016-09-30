export(String, "chest", "head", "hands") var type = "none"
const loader = preload("res://scripts/GearTextureLoader.gd")

# Needs a dict with information, either parsed from json files or built procedurally
# Loads the needed textures, applies them when equipped.
# Not sure if it needs an unequip method.
# Will generate a statsmodule (or similar), need to update StatsModule to collect stats from gear.
# Player should have a dict(?) of equipped items that StatsModule reads from.

func _init(type, data).(type, data):
    pass
