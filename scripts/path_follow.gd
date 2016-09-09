
extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var going = true
var speed = 100

func _ready():
	# print("!!!")
	set_fixed_process(true)

func _fixed_process(delta):
	var n = get_node("Path2D").get_child(0)
	# print(n.get_unit_offset())
	# print("hei")
	# Check if we're looping, if not walk backwards when we reach the end
#    if n.has_loop():
	n.set_offset(n.get_offset() + speed * delta)
#    else:
#        if going:
#            if n.get_unit_offset() < 1.0:
#                n.set_offset(n.get_offset() + speed * delta)
#            else:
#                going = false
#        else:
#            if n.get_unit_offset() > 0.0:
#                n.set_offset(n.get_offset() - speed * delta)
#            else:
#                going = true

	# set_rot(n.get_rot())
	set_pos(n.get_pos())
	set_rot(n.get_rot())
	# var av = get_pos() - get_tree().get_root().get_node("TheLabel").get_global_mouse_pos()
	# print(get_tree().get_root().get_node("TheLabel").get_global_mouse_pos())
	# var r = atan2(av.x, av.y) + 90
	# print(get_children())
