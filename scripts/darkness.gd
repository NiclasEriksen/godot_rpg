
extends CanvasModulate

signal nightmode(state)

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_HUD_nightmode(state):
	# print(not state)
	emit_signal("nightmode", state)
	set_hidden(not state)
