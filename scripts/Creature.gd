
extends KinematicBody2D

signal attack
signal moving
signal stopped
onready var stats = get_node("StatsModule")
var last_pos = null
var moving = false

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# set_pos(Vector2(100, 100))
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	if not get_pos() == last_pos:
		emit_signal("moving")
	else:
		emit_signal("stopped")
	last_pos = get_pos()

func _input(event):
	if event.is_action_pressed("ATTACK"):
		emit_signal("attack")
