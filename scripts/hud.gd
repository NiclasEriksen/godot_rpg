extends Node2D

var player = null

func _ready():
	set_fixed_process(true)
	player = get_tree().get_root().get_node("Game").get_node("Player_object")

func _fixed_process(delta):
	if player:
		get_node("ResourceBars/HealthBar").set_value(float(player.get("cur_hp")) / float(player.get("max_hp")) * 100.0)