extends AnimationTreePlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_active(true)
	# oneshot_node_stop("oneshot")

func _on_Player_moved(pos, rot):
	if not transition_node_get_current("state") == 1:
		transition_node_set_current("state", 1)


func _on_Player_stopped():
	if not transition_node_get_current("state") == 0:
		transition_node_set_current("state", 0)
