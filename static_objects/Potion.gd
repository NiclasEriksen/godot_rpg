extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_z(0)


func _on_Area2D_area_enter(area):
	print(area)


func pick_up():
	get_node("AnimationPlayer").play("pick_up")
	get_node("Area2D").set_enable_monitoring(false)	# Disable collision check
	# print("Picked up!")



func _on_Area2D_body_enter( body ):
	if body == get_tree().get_root().get_node("Game").get_node("Player_object"):
		pick_up()
	# print(body)

func _on_AnimationPlayer_finished():
	queue_free()	# Delete object
