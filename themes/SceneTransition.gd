
extends CanvasLayer

signal start_load

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func fade_to_map():
	print("FADING")
	get_node("AnimationPlayer").play("FadeBlack")
	# emit_signal("start_load")

func start_loading():
	emit_signal("start_load")
