extends Navigation2D
var path = []
var font = null
var drawTouch = false
var touchPos = Vector2(0,0)
var closestPos = Vector2(0,0)

func _ready():
	font = load("res://resources/mono_font.fnt")
	set_process_input(true)
	# var n = get_node("Genmap1")
	#var w = get_node("/root/globals").MAP_WIDTH
	#var h = get_node("/root/globals").MAP_HEIGHT
	#var clear_tile = n.get_tileset().find_tile_by_name("blank")
	#for x in range(w):
	#	for y in range(h):
	#		n.set_cell(x, y, clear_tile)
	#n.set_cell(4, 5, n.get_tileset().find_tile_by_name("wood_wall_l"))
	#n.set_cell(25, 5, n.get_tileset().find_tile_by_name("wood_wall_r"))
	#for x in range(20):
	#	n.set_cell(5 + x, 5, n.get_tileset().find_tile_by_name("wood_wall_m"))

func _draw():
	if(path.size()):
		for i in range(path.size()):
			draw_string(font,Vector2(path[i].x,path[i].y - 20),str(i+1))
			draw_circle(path[i],10,Color(1,1,1))

		if(drawTouch):
			draw_circle(touchPos,10,Color(0,1,0))
			draw_circle(closestPos,10,Color(0,1,0))


func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.button_index == 1):
			if(path.size()):
				# touchPos = get_parent().get_node("Player_object").get_node("Camera2D").get_translated_pos(Vector2(event.x, event.y))
				touchPos = get_global_mouse_pos()
				drawTouch = true
				closestPos = get_closest_point(touchPos)
				print("Drawing touch")
				update()

		if(event.button_index == 2):
			# var sp = get_parent().get_node("Player_object").get_node("Camera2D").get_translated_pos(Vector2(event.x, event.y))
			var sp = get_global_mouse_pos()
			path = get_simple_path(get_parent().get_node("Mob 2").get_pos(), sp)
			var new_curve = Curve2D.new()
			for p in path:
				# print(p)
				new_curve.add_point(Vector2(p.x, p.y))
			get_parent().get_node("Mob 2").get_node("Path2D").set_curve(new_curve)
			get_parent().get_node("Mob 2").get_node("Path2D").get_node("PathFollow2D").set_unit_offset(0.0)
			get_parent().get_node("Mob 2").get_node("Path2D").get_node("PathFollow2D").set_loop(false)
			# print(get_parent().get_node("Mob 2").get_node("Path2D").get_node("PathFollow2D"))
			# print(path)
			update()
