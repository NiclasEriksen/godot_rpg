extends Node2D

signal pause(state)
signal nightmode(state)
signal chat(state, text)

var player = null

func _ready():
	set_fixed_process(true)
	player = get_tree().get_root().get_node("Game").get_node("Player_object")

func _fixed_process(delta):
	if player:
		if player.get_node("StatsModule"):
			var hp = (float(player.get_node("StatsModule").get("hp")) / float(player.get_node("StatsModule").get("max_hp")) * 100.0)
			get_node("ResourceBars/HealthBar").set_value(hp)
			var mp = (float(player.get_node("StatsModule").get("mp")) / float(player.get_node("StatsModule").get("max_mp")) * 100.0)
			get_node("ResourceBars/ManaBar").set_value(mp)

func _on_PauseButton_toggled(state):
	emit_signal("pause", state)

func _on_HealthBar_value_changed(value):
	get_node("ResourceBars/HealthBar/AnimationPlayer").play("change")


func _on_NightButton_toggled( pressed ):
	emit_signal("nightmode", pressed)

func _on_ChatButton_toggled(state):
	emit_signal("chat", state, "Hey there! Supersexy dialog system ftw. Yey.")
