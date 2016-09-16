
extends Node2D
signal animate_attack
export(String, FILE, "*.tscn") var equipped = null


func _ready():
	if equipped:
		equip(equipped)

func equip(weapon_scene):
	print(weapon_scene)

func unequip():
	print("Unequipping item.")
	for c in get_children():	# Should only be one, but to be sure
		c.queue_free()
		equipped = null

func get_stats():
	if equipped and get_child_count() == 1:
		if get_child(0).get_node("StatsModule"):
			return get_child(0).get_node("StatsModule")
		else:
			print("Equipped item has no stats module.")
	else:
		print("Nothing equipped, or there's more than one thing (BAD).")
