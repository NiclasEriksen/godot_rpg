tool
extends Reference
const FORMAT_TMX = 0
const FORMAT_JSON = 1

var meta_file = ""
var md5 = ""
var meta_data = null
var tilecount = 0
var textures = []

# Load meta data from tmx or json file generated by Tiled
func loadFromFile(path):
	var meta = null
	var file = File.new()
	var newMd5 = file.get_md5(path)
	if md5 != newMd5:
		file.open(path, File.READ)
		if file.is_open():
			var format = FORMAT_TMX
			if path.ends_with(".json"):
				format = FORMAT_JSON
			# parse file content
			var fileContent = file.get_as_text()
			if format == FORMAT_TMX:
				meta = _parseXMLContent(fileContent)
			elif format == FORMAT_JSON:
				meta = _parseJsonContent(fileContent)
			# Check parsed data
			if meta != null:
				if meta["tilesets"].size() == 0:
					meta = null
				else:
					textures.clear()
					tilecount = 0
					for ts in meta["tilesets"]:
						tilecount += ts["tiles"].size()
						for t in ts["tiles"]:
							if textures.find(t["source"]) == -1:
								textures.append(t["source"])
				for l in meta["layers"]:
					var gidata = l["data"]["content"]
					if gidata.size()==0 or gidata.size() != l["height"]*l["width"]:
						meta = null
						break
			file.close()
		# update meta data
		meta_file = path
		meta_data = meta
		if meta != null:
			md5 = newMd5
			return true
		else:
			return false
	else:
		return true
		
################################# GID Parser ##################################

func _parseCSVData(rawStr):
	var array = IntArray()
	var rows = rawStr.split("\n")
	for row in rows:
		var gids = row.split(",")
		for gid in gids:
			if gid and gid.length() > 0:
				array.push_back(int(gid))
	return array

# Parser base64 Data
func _parseBase64Data(rawStr):
	var array = IntArray()
	if type_exists("RawPacker"):
		rawStr = rawStr.strip_edges()
		var bytes = (Marshalls.base64_to_raw(rawStr))
		var sg = ""
		for i in range(bytes.size()/4):
			sg += "I"
		var raw_packer = RawPacker.new()
		print(sg.length())
		array = raw_packer.unpack(sg, bytes)
		print(array.size())
		
	return array

func _parseXMLGidData(parser):
	var array = IntArray()
	while(parser.read() != ERR_FILE_EOF):
		if parser.get_node_type() == parser.NODE_ELEMENT:
			if "tile" == parser.get_node_name():
				var gid = _xmlNodeAttrValue(parser, "gid", 0)
				array.push_back(gid)
				print(gid)
			else:
				break
	return array

################################# JSON Parser #################################

func _parseJsonContent(jsonContent):
	var meta = {};
	if meta.parse_json(jsonContent) == OK:
		if not meta.has("properties"):
			meta["properties"] = {}
		for tileset in meta["tilesets"]:
			var tiles = []
			if tileset.has("tiles"):
				var rawTiles = tileset["tiles"]
				for i in range(rawTiles.size()):
					var tile = {}
					tile["id"] = tileset["firstgid"] + i
					tile["posX"] = 0
					tile["posY"] = 0
					tile["width"] = tileset["tilewidth"]
					tile["height"] = tileset["tileheight"]
					tile["source"] = rawTiles[str(i)]["image"]
					tile["trans"] = Color(1,1,1,1)
					if tileset.has("transparentcolor"):
						tile["trans"] = Color(tileset["transparentcolor"])
					tiles.append(tile)
			else:
				for i in range(tileset["tilecount"]):
					var tile = {}
					tile["id"] = tileset["firstgid"] + i
					if  tileset["columns"] == 0:
						tile["posX"] = tileset["spacing"]
						tile["posY"] = i * tileset["tileheight"] + (i+1) * tileset["margin"]
					else:
						tileset["columns"] = int(tileset["columns"])
						var column = (i%tileset["columns"])
						var row = (i/tileset["columns"])
						tile["posX"] = column * tileset["tilewidth"] + (column+1) * tileset["spacing"]
						tile["posY"] = row * tileset["tileheight"] +  (row+1) * tileset["margin"]
					tile["width"] = tileset["tilewidth"]
					tile["height"] = tileset["tileheight"]
					tile["source"] = tileset["image"]
					tile["trans"] = Color(1,1,1,1)
					if tileset.has("transparentcolor"):
						tile["trans"] = Color(tileset["transparentcolor"])
					tiles.append(tile)
			tileset["tiles"] = tiles
		for layer in meta["layers"]:
			var rawData = layer["data"]
			var data = {}
			data["encoding"] = "csv"
			data["compression"] = ""
			if layer.has("encoding"):
				data["encoding"] = layer["encoding"]
			if layer.has("compression"):
				data["compression"] = layer["compression"]
			if data["encoding"] == "csv":
				data["content"] = rawData
			elif data["encoding"] == "base64":
				data["content"] = _parseBase64Data(rawData)
			# TODO Other tile gid
			else:
				data["content"] = IntArray()
			layer["data"] = data
			if not layer.has("offsetx"):
				layer["offsetx"] = 0
			if not layer.has("offsety"):
				layer["offsety"] = 0
			if not layer.has("properties"):
				layer["properties"] = {}
	else:
		meta = null
	return meta

################################# XML Parser ##################################

func _parseXMLContent(xmlContent):
	var parser = XMLParser.new()
	var meta = null
	if OK == parser.open_buffer(xmlContent.to_utf8()):
		var err = parser.read()
		if err == OK:
			meta = {}
			meta["tilesets"] = []
			meta["layers"] = []
			var iterated = false
			while(err != ERR_FILE_EOF):
				iterated = false
				if parser.get_node_type() == parser.NODE_ELEMENT:
					if "map" == parser.get_node_name():
						meta["version"] = _xmlNodeAttrValue(parser, "version", 1)
						meta["orientation"] = _xmlNodeAttrValue(parser, "orientation", "orthogonal")
						meta["renderorder"] = _xmlNodeAttrValue(parser, "renderorder", "right-down")
						meta["width"] = _xmlNodeAttrValue(parser, "width", 0)
						meta["height"] = _xmlNodeAttrValue(parser, "height", 0)
						meta["tilewidth"] = _xmlNodeAttrValue(parser, "tilewidth", 0)
						meta["tileheight"] = _xmlNodeAttrValue(parser, "tileheight", 0)
						meta["nextobjectid"] = _xmlNodeAttrValue(parser, "nextobjectid", 0)
						meta["properties"] = {}
						while(parser.read() != ERR_FILE_EOF):
							if parser.get_node_type() == parser.NODE_ELEMENT:
								if "properties" == parser.get_node_name():
									while(parser.read() != ERR_FILE_EOF):
										if parser.get_node_type() == parser.NODE_ELEMENT:
											if "property" == parser.get_node_name():
												var type = _xmlNodeAttrValue(parser, "type", "string")
												var name = _xmlNodeAttrValue(parser, "name", "unnamed")
												var value = _xmlNodeAttrValue(parser, "value", "0")
												if type == "int":
													value = int(value)
												elif type == "float":
													value = float(value)
												elif type == "bool":
													value = bool(value)
												meta["properties"][name] = value
											else:
												break
								if "tileset" == parser.get_node_name():
									iterated = true
									break
					# tilesets
					elif "tileset" == parser.get_node_name():
						var tileset = {}
						tileset["firstgid"] = _xmlNodeAttrValue(parser, "firstgid", 1)
						tileset["name"] = _xmlNodeAttrValue(parser, "name", "tileset")
						tileset["tilecount"] = _xmlNodeAttrValue(parser, "tilecount", 0)
						tileset["columns"] = _xmlNodeAttrValue(parser, "columns", 0)
						tileset["tilewidth"] = _xmlNodeAttrValue(parser, "tilewidth", 0)
						tileset["tileheight"] = _xmlNodeAttrValue(parser, "tileheight", 0)
						tileset["spacing"] = _xmlNodeAttrValue(parser, "spacing", 0)
						tileset["margin"] = _xmlNodeAttrValue(parser, "margin", 0)
						tileset["tiles"] = []
						while(parser.read() != ERR_FILE_EOF):
							if parser.get_node_type() == parser.NODE_ELEMENT:
								if "tile" == parser.get_node_name():
									var tile = {}
									tile["id"] = tileset["firstgid"] + _xmlNodeAttrValue(parser, "id", 1)
									# image under title
									while(parser.read() != ERR_FILE_EOF):
										if parser.get_node_type() == parser.NODE_ELEMENT:
											if "image" == parser.get_node_name():
												tile["posX"] = 0
												tile["posY"] = 0
												tile["width"] = _xmlNodeAttrValue(parser, "width", 0)
												tile["height"] = _xmlNodeAttrValue(parser, "height", 0)
												tile["source"] = _xmlNodeAttrValue(parser, "source", "")
												tile["trans"] = _xmlNodeAttrValue(parser, "trans", Color(1,1,1,1))
												break
									tileset["tiles"].append(tile)
									continue
								if "image" == parser.get_node_name():
									for i in range(tileset["tilecount"]):
										var tile = {}
										tile["id"] = tileset["firstgid"] + i
										if  tileset["columns"] == 0:
											tile["posX"] = tileset["spacing"]
											tile["posY"] = i * tileset["tileheight"] + (i+1) * tileset["margin"]
										else:
											var column = (i%tileset["columns"])
											var row = (i/tileset["columns"])
											tile["posX"] = column * tileset["tilewidth"] + (column+1) * tileset["spacing"]
											tile["posY"] = row * tileset["tileheight"] +  (row+1) * tileset["margin"]
										tile["width"] = tileset["tilewidth"]
										tile["height"] = tileset["tileheight"]
										tile["source"] = _xmlNodeAttrValue(parser, "source", "")
										tile["trans"] = _xmlNodeAttrValue(parser, "trans", Color(1,1,1,1))
										tileset["tiles"].append(tile)
									# Never change the indent below!
									break
								elif "tileset" == parser.get_node_name():
									iterated = true
									break
								else:
									break
						meta["tilesets"].append(tileset)
					# layers
					if "layer" == parser.get_node_name():
						var layer = {}
						layer["name"] = _xmlNodeAttrValue(parser, "name", "Unnamed")
						layer["width"] = _xmlNodeAttrValue(parser, "width", 0)
						layer["height"] = _xmlNodeAttrValue(parser, "height", 0)
						layer["visible"] = _xmlNodeAttrValue(parser, "visible", true)
						layer["opacity"] = _xmlNodeAttrValue(parser, "opacity", 1.0)
						layer["offsetx"] = _xmlNodeAttrValue(parser, "offsetx", 0.0)
						layer["offsety"] = _xmlNodeAttrValue(parser, "offsety", 0.0)
						layer["properties"] = {}
						while(parser.read() != ERR_FILE_EOF):
							if parser.get_node_type() == parser.NODE_ELEMENT:
								if "properties" == parser.get_node_name():
									while(parser.read() != ERR_FILE_EOF):
										if parser.get_node_type() == parser.NODE_ELEMENT:
											if "property" == parser.get_node_name():
												var type = _xmlNodeAttrValue(parser, "type", "string")
												var name = _xmlNodeAttrValue(parser, "name", "unnamed")
												var value = _xmlNodeAttrValue(parser, "value", "0")
												if type == "int":
													value = int(value)
												elif type == "float":
													value = float(value)
												elif type == "bool":
													value = bool(value)
												layer["properties"][name] = value
											else:
												break
								if "data" == parser.get_node_name():
									var data = {}
									data["encoding"] = _xmlNodeAttrValue(parser, "encoding", "xml")
									data["compression"] = _xmlNodeAttrValue(parser, "compression", "")
									if data["encoding"] == "xml":
										data["content"] = _parseXMLGidData(parser)
										if parser.get_node_name() == "layer":
											iterated = true
									else:
										var content = ""
										if parser.read() != ERR_FILE_EOF and parser.get_node_type() == parser.NODE_TEXT:
											content = parser.get_node_data()
										if data["encoding"] == "csv":
											data["content"] = _parseCSVData(content)
										elif data["encoding"] == "base64":
											data["content"] = _parseBase64Data(content)
										# TODO Other tile gid
										else:
											data["content"] = IntArray()
									layer["data"] = data
									break
						meta["layers"].append(layer)
				if iterated:
					continue
				# iterater current element
				err = parser.read()
	return meta

func _xmlNodeAttrValue(parser, attName, defaultV):
	var res = defaultV
	if parser and parser.has_attribute(attName):
		res = parser.get_named_attribute_value(attName)
	var tarType = typeof(defaultV)
	if typeof(res) != tarType:
		if tarType == TYPE_INT:
			res = int(res)
		elif tarType == TYPE_BOOL:
			if res.length() > 0:
				res = bool(int(res))
			else:
				res = false
		elif tarType == TYPE_REAL:
			res = float(res)
		elif tarType == TYPE_COLOR:
			res = Color(res)
	return res
