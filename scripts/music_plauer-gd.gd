extends StreamPlayer

func _ready():
	self.play()
	self.set_paused(true)

func _on_MusicButton_toggled( pressed ):
	if self.is_paused():
		self.set_paused(false)
	else:
		self.set_paused(true)
