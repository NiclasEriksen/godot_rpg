extends Camera2D

var zoom_rate = Vector2(0.02, 0.02)
var min_zoom = Vector2(0.1, 0.1)
var max_zoom = Vector2(1, 1)

func _ready():
	set_process_input(true)

func shake():
	var ap = get_node("AnimationPlayer")
	# ap.play("ScreenShake")
	if not ap.is_playing():
		ap.play("ScreenShake")

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_DOWN:
			if get_zoom() < max_zoom:
				set_zoom(get_zoom() + zoom_rate)
		if event.button_index == BUTTON_WHEEL_UP:
			if get_zoom() > min_zoom:
				set_zoom(get_zoom() - zoom_rate)

func get_translated_pos(pos):
	return (pos - get_viewport_rect().size / 2) * get_zoom() + get_camera_pos()

func _on_Player_object_moved(pos, rot):
	self.set_pos(pos)
	self.set_rot(rot + PI)


func _on_Player_object_jump():
	shake()
