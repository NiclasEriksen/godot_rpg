extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var attr = "hp"
var amount = 2.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_z(0)


func pick_up(picker):
	get_node("AnimationPlayer").play("pick_up")
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	# get_node("Area2D").set_enable_monitoring(false)	# Disable collision check
	picker.apply_stat("increase", attr, amount)



func _on_Area2D_body_enter( body ):
	var p = get_tree().get_root().get_node("Game").find_node("Player_object")
	if body == p:
		pick_up(p)
	# print(body)

func _on_AnimationPlayer_finished():
	queue_free()	# Delete object
