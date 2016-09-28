extends Node2D

signal pause(state)
signal nightmode(state)
signal chat(state, text)

var player = null
onready var nc = get_node("/root/notifications")
var hp_bar_scn = preload("res://components/HPBar.tscn")

func _ready():
	set_process(true)
	player = get_tree().get_root().get_node("Game").get_node("Player_object")
	nc.add_observer(self, "player_hp", "update_resource")

func add_hpbar(owner):
	var hpb = hp_bar_scn.instance()
	hpb.register(owner)
	get_node("HPBars").add_child(hpb)

func update_resource(obs, type, data):
	print("wat")
	if type == "player_hp":
		get_node("ResourceBars/HealthBar").set_value(data)
	elif type == "player_mp":
		get_node("ResourceBars/ManaBar").set_value(data)

func _process(delta):
	pass

func _on_PauseButton_toggled(state):
	emit_signal("pause", state)

func _on_HealthBar_value_changed(value):
	get_node("ResourceBars/HealthBar/AnimationPlayer").play("change")


func _on_NightButton_toggled( pressed ):
	emit_signal("nightmode", pressed)

func _on_ChatButton_toggled(state):
	emit_signal("chat", state, "Hey there! Supersexy dialog system ftw. Yey.")
