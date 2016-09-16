
extends Area2D

export(String) var map_name = "None"
signal change_map(body, name)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_MapChangeTrigger_body_enter( body ):
	emit_signal("change_map", body, map_name)
