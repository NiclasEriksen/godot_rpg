
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

func _input(event):
	if event.is_action_released("QUIT"):
		# get_tree().set_input_as_handled()
		get_tree().set_pause(false)
		# get_tree().get_root().get_node("Game").queue_free()
		get_node("/root/globals").set_scene("res://MainMenu.tscn")
