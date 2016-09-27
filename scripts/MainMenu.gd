
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
		get_node("/root/MainMenu").setScene("res://TestScene.tscn")
