extends Control

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_Button_2_toggled( pressed ):
	get_tree().set_pause(pressed)
	