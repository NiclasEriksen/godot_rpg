
extends Node

var currentScene = null
var map = null
onready var cur1 = load("res://resources/ui/cursor1.png")
onready var cur2 = load("res://resources/ui/cursor2.png")
onready var itemloader = preload("res://scripts/ItemLoader.gd").new()
onready var items = itemloader.load_items()

var PlayerName = "Niclas"
var MAP_WIDTH = 40
var MAP_HEIGHT = 30

func _ready():
	# print(currentScene, "hei")
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.is_pressed():
			Input.set_custom_mouse_cursor(cur2)
		else:
			Input.set_custom_mouse_cursor(cur1)

func set_scene(scene):
	currentScene.queue_free()
	var nc = get_node("/root/notifications")
	nc.notifications.clear()
	var s = ResourceLoader.load(scene)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)

func set_map(mapname):
	var mappath = "res://maps/" + mapname
	if (File.new().file_exists(mappath)):
		map = mappath
		return true
	else:
		print("Map not found: ", mappath)
		return false

func get_map():
	return map

func get_player_name():
	return PlayerName
