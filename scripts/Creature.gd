
extends KinematicBody2D

signal attack
signal moving
signal stopped
onready var stats = get_node("StatsModule")
onready var root = get_tree().get_root().get_node("Game")
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
	set_process(true)
	root.get_node("UILayer").get_node("HUD").add_hpbar(self)


func die():
	queue_free()

func _process(delta):
	if stats.get("hp") <= 0:
		die()


func _fixed_process(delta):
	if not get_pos() == last_pos:
		emit_signal("moving")
	else:
		emit_signal("stopped")
	last_pos = get_pos()

func _input(event):
	if event.is_action_pressed("ATTACK"):
		pass
		#emit_signal("attack")
