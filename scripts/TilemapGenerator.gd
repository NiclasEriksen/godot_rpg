
extends TileMap

const mg = preload("mapgen.gd")
var ts = null

func _ready():
	var w = get_node("/root/globals").MAP_WIDTH
	var h = get_node("/root/globals").MAP_HEIGHT
	clear()
	ts = get_tileset()
	var ground = ts.find_tile_by_name("ground_stone")
	var grass = ts.find_tile_by_name("ground_grass")
	for x in range(w):
		for y in range(h):
			var flip_x = false
			if rand_range(0, 5) < 1:
				if randi()%2 == 1:
					flip_x = true
				self.set_cell(x, y, ground, flip_x)
			else:
				if randi()%2 == 1:
					flip_x = true
				self.set_cell(x, y, grass, flip_x)
	# print(ts.find_tile_by_name("ground_grass"))

