extends SamplePlayer2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Timer_timeout():
	play("dunk")
	
func _on_Player_attack():
	play("dunk")