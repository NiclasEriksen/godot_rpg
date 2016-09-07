extends Node

var prev_arm = "left"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var l_arm = null
var r_arm = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	l_arm = get_node("LeftArmPlayer")
	r_arm = get_node("RightArmPlayer")


func _on_Creature_attack():
	if prev_arm == "left":
		r_arm.play("creature_punch_right")
		prev_arm = "right"
	else:
		l_arm.play("creature_punch_left")
		prev_arm = "left"
