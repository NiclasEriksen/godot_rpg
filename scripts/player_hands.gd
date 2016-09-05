
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)

func _process(delta):
	get_node("Weapon").set_offset(get_offset())
