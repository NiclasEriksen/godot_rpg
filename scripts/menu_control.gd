
extends VBoxContainer


func _ready():
	set_process_input(true)
	set_focus_mode(2)
	var ml = get_node("MapList")
	var maps = get_maps()
	for m in maps:
		ml.add_item(m, null, true)

func get_maps():
	var dir = Directory.new()
	var mapfiles = []
	if dir.open("maps") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				pass
			else:
				if file_name.ends_with(".tscn"):
					mapfiles.append(file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return mapfiles

func _input(event):
	if event.is_action("QUIT"):
		get_tree().quit()


func _on_MapList_item_selected(index):
	get_node("/root/globals").set_map(get_node("MapList").get_item_text(index))

func _on_NewGame_released():
	get_node("/root/globals").set_scene("res://TestScene.tscn")


func _on_TestScene_released():
	if get_node("/root/globals").get_map():
		get_node("/root/globals").set_scene("res://TestScene.tscn")
	else:
		get_parent().get_node("PopupDialog").popup_centered()


func _on_Quit_released():
	get_tree().quit()


func _on_MapList_item_activated( index ):
	if get_node("/root/globals").get_map():
		get_node("/root/globals").set_scene("res://TestScene.tscn")
