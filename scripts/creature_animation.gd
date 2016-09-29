
extends AnimationPlayer

var last_attack = "left"

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	# animation_set_next("PunchRight", "Rest")
	# animation_set_next("PunchLeft", "Rest")




func _on_Creature_attack():
	if is_playing():
		stop()
	if last_attack == "left":
		play("PunchRight")
		# animation_set_next("PunchRight", "Rest")
		last_attack = "right"
	else:
		play("PunchLeft")
		last_attack = "left"


func _on_HandAnimation_finished():
	# stop(true)
	if not get_current_animation() == "Rest":
		# print("Resting")
		play("Rest")
