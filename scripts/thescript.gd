extends Control
var globals = null
var map = null

func _ready():
	set_process(true)
	globals = get_node("/root/globals")
	if globals:
		if globals.get_map():
			map = load(globals.get_map())
			get_node("Nav").get_node("Map").free()
			get_node("Nav").add_child(map.instance())
	else:
		print("Globals not loaded, PANICK!")

func _process(delta):
	pass

func load_map():
	if globals.get_map():
		map = load(globals.get_map())
		for n in get_node("Nav").get_children():
			n.free()
		get_node("Nav").add_child(map.instance())
		for c in get_node("Nav").get_children():
			if get_node("Nav").get_child_count() == 1:
				c.set_name("Map")
			else:
				print("More than one map loaded??!")
	else:
		print("No map specified in globals...")

func change_map(mapname):
	if globals.set_map(mapname):
		SceneTransition.connect("start_load", self, "load_map", [])
		SceneTransition.fade_to_map()
	else:
		print("Failed to set map: ", mapname)

func _on_HUD_pause(pressed):
	get_tree().set_pause(pressed)


func _on_MapChangeTrigger_change_map(body, name):
	if body.get_name() == "Player_object":
		change_map(name)
