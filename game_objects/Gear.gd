var loader = preload("res://scripts/GearTextureLoader.gd").new()

# Needs a dict with information, either parsed from json files or built procedurally
# Loads the needed textures, applies them when equipped.
# Not sure if it needs an unequip method.
# Will generate a statsmodule (or similar), need to update StatsModule to collect stats from gear.
# Player should have a dict(?) of equipped items that StatsModule reads from.
var type = null

var name = null
var desc = null
var ilvl = null
var rarity = null
var material = null
var weight = null
var texture = null
var icon = null
var stats = {}
var special = null


func _init(type, data):
    self.type = type

    self.name = data["name"]
    self.desc = data["description"]
    self.ilvl = data["itemlevel"]
    self.rarity = data["rarity"]
    self.material = data["material"]
    self.weight = data["weight"]
    self.special = data["special"]
    self.stats = data["stats"]
    self.texture = loader.get_texture(type, data["texture"])

func equip(target):
    loader.wear_gear(target, self.type, self.texture)
