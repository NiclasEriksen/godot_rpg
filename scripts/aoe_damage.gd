extends Sprite

export(int) var damage = 2
var targets = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func do_damage(entity):
	if entity.get_node("StatsModule"):
		print("Hey?")
		# get_node("AnimationPlayer").play("pick_up")
		# get_node("Area2D").call_deferred("set_enable_monitoring", false)
		# get_node("Area2D").set_enable_monitoring(false)	# Disable collision check
		# picker.apply_stat("increase", attr, amount)
		entity.get_node("StatsModule").apply_effect([["hp", -2]], null)


func _on_Area2D_body_enter(body):
	var p = get_tree().get_root().get_node("Game").find_node("Player_object")
	if body == p:
		if not targets.has(body):
			targets.append(body)
	# print(body)


func _on_poison_tick():
	for t in targets:
		do_damage(t)


func _on_Area2D_body_exit(body):
	if targets.has(body):
		targets.erase(body)
