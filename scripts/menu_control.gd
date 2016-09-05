
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action("QUIT"):
		get_tree().quit()


func _on_MenuButton_pressed():
	get_node("/root/globals").set_scene("res://TestScene.tscn")


func _on_MenuButton_3_pressed():
	get_tree().quit()
