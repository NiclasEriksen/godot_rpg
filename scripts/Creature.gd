
extends KinematicBody2D

signal attack
var attacking = false

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_pos(Vector2(100, 100))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ATTACK"):
		if not attacking:
			emit_signal("attack")
			attacking = true
	else:
		attacking = false
