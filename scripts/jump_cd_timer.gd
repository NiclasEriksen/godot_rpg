
extends Timer

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Mob_jump():
	self.start()


func _on_JumpCooldownTimer_timeout():
	self.stop()
