extends Control

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_HUD_pause(pressed):
	get_tree().set_pause(pressed)
