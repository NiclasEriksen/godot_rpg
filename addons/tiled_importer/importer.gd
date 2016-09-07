tool
extends Control

var MapParser = preload("map.gd")
var map = MapParser.new()
var textureCache = TextureCache.new()

onready var dialog = get_node("Dialog")
onready var info = get_node("Dialog/VBox/Info")
onready var inputField = get_node("Dialog/VBox/Input/LineEdit")
onready var outputField = get_node("Dialog/VBox/Output/LineEdit")
onready var fileDialog = get_node("Dialog/FileDialog")
onready var alter = get_node("Dialog/Alter")
onready var warning = get_node("Dialog/VBox/Warning")

signal confim_import(path, meta)

func alter(msg):
	alter.set_text(msg)
	alter.popup()

func showDialog(from):
	var meta = null
	info.set_text("")
	if from and from.length()>0:
		meta = ResourceLoader.load_import_metadata(from)
		if meta:
			inputField.set_text(meta.get_option("srcfile"))
			outputField.set_text(meta.get_option("tarScene"))
	else:
		inputField.set_text("")
		outputField.set_text("")
	_check("")
	dialog.popup()


func _getFileName(path):
	var fileName = path.substr(path.find_last("/")+1, path.length() - path.find_last("/")-1)
	var dotPos = fileName.find_last(".")
	if dotPos != -1:
		fileName = fileName.substr(0,dotPos)
	return fileName

func _getParentDir(path):
	var fileName = path.substr(0, path.find_last("/"))
	return fileName

func _pathJoin(base, path):
	var p = base + "/" + path
	p = p.replace("//", "/")
	var nodes = p.split("/")
	var tmp = []
	for n in nodes:
		if n == "..":
			tmp.pop_back()
		elif n.length()>0 and n!=".":
			tmp.push_back(n)
	var res = ""
	if base.begins_with("/"):
		res += "/"
	for i in range(tmp.size()):
		res += tmp[i]
		if i < tmp.size()-1:
			res += "/"
	return res

func _confirmed():
	if _check(""):
		var inpath = inputField.get_text()
		var outfile = outputField.get_text()
		var meta = ResourceImportMetadata.new()
		meta.set_editor("com.geequlim.gdplugin.importer.tiled")
		meta.add_source(inpath)
		meta.set_option("tarScene", outfile)
		meta.set_option("srcfile", inpath)
		emit_signal("confim_import", outfile, meta)
		dialog.hide()
	else:
		alter(warning.get_text())

func _ready():
	info.set_readonly(true)
	get_node("Dialog/VBox/Input/Button").connect("pressed", self, "_browseInput")
	get_node("Dialog/VBox/Output/Button").connect("pressed", self, "_browseOutput")
	inputField.connect("text_changed", self, "_check")
	outputField.connect("text_changed", self, "_check")
	fileDialog.connect("file_selected", self, "_fileSelected")
	if not get_tree().is_editor_hint():
		warning.set_text("")
	dialog.get_ok().set_text("Import")
	dialog.set_hide_on_ok(false)
	dialog.get_ok().connect("pressed", self, "_confirmed")
	dialog.set_pos(Vector2(get_viewport_rect().size.width/2 - dialog.get_rect().size.width/2, get_viewport_rect().size.height/2 - dialog.get_rect().size.height/2))
	# showDialog("")

func _browseInput():
	fileDialog.set_mode(FileDialog.MODE_OPEN_FILE)
	fileDialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	fileDialog.clear_filters()
	fileDialog.add_filter("*.tmx")
	fileDialog.add_filter("*.json")
	fileDialog.popup()

func _browseOutput():
	fileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
	fileDialog.set_access(FileDialog.ACCESS_RESOURCES)
	fileDialog.clear_filters()
	fileDialog.add_filter("*.tscn")
	fileDialog.add_filter("*.scn")
	fileDialog.add_filter("*.res")
	fileDialog.add_filter("*.xscn")
	fileDialog.add_filter("*.xml")
	var presetname = _getFileName(inputField.get_text())
	if presetname == null:
		presetname = ""
	fileDialog.set_current_file(str(presetname,".tscn"))
	fileDialog.popup()

func _fileSelected(path):
	if fileDialog.get_mode() == FileDialog.MODE_OPEN_FILE:
		inputField.set_text(path)
	elif fileDialog.get_mode() == FileDialog.MODE_SAVE_FILE:
		outputField.set_text(path)
	_check(path)

# Check user input and parsed
func _check(unused):
	info.set_text("")
	var inputPath = inputField.get_text()
	var outputPath = outputField.get_text()
	var file = File.new()
	var passed = true
	var dir = Directory.new()
	var outDir = outputPath.substr(0, outputPath.find_last("/"))
	if not file.file_exists(inputPath):
		warning.set_text("The input file does not exists!")
		passed = false
	if passed:
		if not map.loadFromFile(inputPath):
			warning.set_text("Parse map file failed!")
			passed = false
			return passed
		else:
			var infoTex = str("Tileset count: ", map.tilecount, "\n\n")
			infoTex += "Layers:\n"
			for l in map.meta_data["layers"]:
				infoTex += str("  ",l["name"], "\n")
			infoTex += "\n"

			infoTex += "Textures to import:\n"
			var srcDir = _getParentDir(map.meta_file)
			for tp in map.textures:
				infoTex += str("  ",  _pathJoin(srcDir,tp), "\n")
			infoTex += "\n"
			info.set_text(infoTex)
	if not outputPath.begins_with("res://") or outputPath == "res://":
		warning.set_text("Output file must under project folder!")
		passed = false
	elif not dir.dir_exists(outDir):
		if outDir != "res:/":
			warning.set_text("Output directory does not exists!")
			passed = false
	if passed:
		warning.set_text("")
	return passed

func import(path, meta):
	path = meta.get_option("tarScene")
	var srcfile = meta.get_option("srcfile")
	if map.loadFromFile(srcfile):
		meta.set_editor('com.geequlim.gdplugin.importer.tiled')
		meta.set_source_md5(0, File.new().get_md5(srcfile))
		var mapScene = _processSubRes(path, meta)
		# The import meta data was attached to tileset
		mapScene.set_import_metadata(meta)
		ResourceSaver.save(path, mapScene)

func _processSubRes(scenePath, imptMeta):
	var meta = map.meta_data
	var dir = scenePath.substr(0, scenePath.find_last("/"))
	var tarName = _getFileName(scenePath)
	if meta != null:
		var src_dir = _getParentDir(map.meta_file)
		# Tileset
		var tsPath = str(dir,"/", tarName,".tilesets",".res")
		var rts = null
		if (ResourceLoader.has(tsPath)):
			rts = ResourceLoader.load(tsPath)
		else:
			rts = TileSet.new()
		rts.clear()
		rts.set_path(tsPath)
		rts.set_name(_getFileName(tsPath))
		# Save imptMeta into tileset as it doesn't work for packed scene
		rts.set_import_metadata(imptMeta)
		var tmpTextures = []
		for ts in meta["tilesets"]:
			for t in ts["tiles"]:
				var src_tex_path = _pathJoin(src_dir, t["source"])
				# Save texture
				if tmpTextures.find(src_tex_path) == -1:
					var tex_name = _getFileName(src_tex_path)
					var dst_tex_path = str(dir,"/",tarName,".",tex_name,".tex")
					var tex = textureCache.get(src_tex_path, dst_tex_path)
					tex.set_name(tex_name)
					ResourceSaver.save(dst_tex_path,tex)
					tmpTextures.append(src_tex_path)
				# Add tile
				var id = t["id"]
				var tex = textureCache.get_ref(src_tex_path)
				if tex != null:
					rts.create_tile(id)
					rts.tile_set_texture(id, tex)
					rts.tile_set_region(id, Rect2(t["posX"],t["posY"], t["width"],t["height"]))
					rts.tile_set_name(id, str("Tile", id))
		ResourceSaver.save(tsPath, rts)

		# Map node
		# 1. Create layers
		var layers = []
		for l in meta["layers"]:
			var layer = TileMap.new()
			layer.set_name(l["name"])
			layer.set_pos(Vector2(l["offsetx"], l["offsety"]))
			layer.set_opacity(l["opacity"])
			layer.set_hidden(!l["visible"])
			layer.set_cell_size(Vector2(meta["tilewidth"], meta["tileheight"]))
			var scriptSource = "tool\nextends TileMap\n\n"
			scriptSource += _exportDictionary(l["properties"])
			var script = GDScript.new()
			script.set_source_code(scriptSource)
			layer.set_script(script)
			var mode = TileMap.MODE_SQUARE
			if meta["orientation"] == "isometric":
				mode = TileMap.MODE_ISOMETRIC
			layer.set_mode(mode)
			layer.set_tileset(rts)
			var gidata = l["data"]["content"]
			for y in range(l["height"]):
				for x in range(l["width"]):
					layer.set_cell(x, y, gidata[y * l["width"] + x])
			layers.append(layer)
		# 2. Save map scene
		var packer = null
		if ResourceLoader.has(scenePath):
			packer = ResourceLoader.load(scenePath)
		else:
			packer = PackedScene.new()
		packer.set_path(scenePath)
		packer.set_name(_getFileName(scenePath))

		var node = Node2D.new()
		var script = GDScript.new()
		var scriptCode = "tool\nextends Node2D\n\n"
		scriptCode += _exportDictionary(meta["properties"])
		script.set_source_code(scriptCode)
		node.set_script(script)
		for l in layers:
			if l.get_parent():
				l.get_parent().remove_child(l)
				l.set_owner(null)
			node.add_child(l)
			l.set_owner(node)
		packer.pack(node)
		return packer
	return null

func _exportDictionary(d):
	var res = ""
	for k in d:
		var type = null
		var value = d[k]
		k = k.replace(" ", "")
		if typeof(k) == TYPE_BOOL:
			type = "bool"
		elif typeof(k) == TYPE_REAL:
			type = "float"
		elif typeof(k) == TYPE_INT:
			type = "float"
		else:
			type = "String"
			value = str("\"", value, "\"")
		res += str("export(", type,") var ", k, " = ", value, "\n")
	return res

class TextureCache extends Reference:
	var _src_md5_map = {}
	var _src_tex_map = {}

	func get(src, dst):
		var file = File.new()
		var tex = null
		if file.file_exists(src):
			var md5 = file.get_md5(src)
			if ResourceLoader.has(dst):
				tex = ResourceLoader.load(dst)
			else:
				tex = ImageTexture.new()
				tex.set_path(dst)
			if not _src_md5_map.has(src) or (not ResourceLoader.has(dst)) or _src_md5_map[src] != md5:
				tex.load(src)
			_src_md5_map[src] = md5
			_src_tex_map[src] = tex
		return tex

	func get_ref(src):
		if _src_tex_map.has(src):
			return _src_tex_map[src]
		else:
			return null
