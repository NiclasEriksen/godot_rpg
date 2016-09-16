
extends Node

var currentScene = null
var map = null

var PlayerName = "Niclas"
var MAP_WIDTH = 40
var MAP_HEIGHT = 30

func _ready():
	# print(currentScene, "hei")
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)

func set_scene(scene):
	currentScene.queue_free()
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
