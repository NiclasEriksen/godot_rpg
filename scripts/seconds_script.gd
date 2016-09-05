
extends RichTextLabel

# member variables here, example:
# var a=2
# var b="textvar"
var seconds = 0
onready var globals = get_node("/root/globals")

func _ready():
	self.make_label()
#	self.add_text("Joda...!")
#	for i in range(10):
#		self.add_text("\n" + str(i) + str(rand_range(0, 4)))
	# Called every time the node is added to the scene.
	# Initialization here


func make_label():
	self.clear()
	self.add_text(str("Player: ", globals.get_player_name(), " Seconds: " + str(seconds)))


func _on_Timer_timeout():
	seconds += 1
	self.make_label()
