
extends VBoxContainer

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action("QUIT"):
		get_tree().quit()


func _on_NewGame_released():
	get_node("/root/globals").set_scene("res://TestScene.tscn")


func _on_TestScene_released():
	get_node("/root/globals").set_scene("res://TestScene.tscn")


func _on_Quit_released():
	get_tree().quit()

