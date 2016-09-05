var count = 0
signal moved

func _ready():
	pass
	# connect("moved", self, "Camera2D")
	# var cam = get_node("Camera2D")
	# cam.connect("moved", self, "sprite_moved")

func _draw():
	pass
		# var pos = Vector2(self.get_parent().get_rect().size.width/2, self.get_parent().get_rect().size.height/2)


func _on_Timer1_timeout():
	count += 0.5
	var pos = self.get_pos() + Vector2(0.3, 0)
	self.set_pos(pos)
	self.emit_signal("moved")
	# self._draw()
	# pass # replace with function body
