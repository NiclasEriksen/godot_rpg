extends Control

func _ready():
	set_process(true)
	if get_node("/root/globals").get_map():
		var map = load(get_node("/root/globals").get_map())
		get_node("Navigation2D").get_node("Map").free()
		get_node("Navigation2D").add_child(map.instance())

func _process(delta):
	pass

func _on_HUD_pause(pressed):
	get_tree().set_pause(pressed)
