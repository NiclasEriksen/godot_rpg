tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("DynamicNumber","Node2D",preload("res://addons/dynamic_number/dynamic_number.gd"),preload("res://addons/dynamic_number/icon.png"))

func _exit_tree():
	remove_custom_type("DynamicNumber")
