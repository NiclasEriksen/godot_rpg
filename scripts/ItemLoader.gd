var base_dir = "game_objects/equipment/"
var armor_types = ["chest", "head", "hands"]
var weapon_types = ["sword", "mace", "staff", "bow", "dagger"]
const gear = preload("res://game_objects/Gear.gd")

func load_items():
    var items = {
        armor={},
        weapon={}
    }
    var full_dir = ""
    var dir = Directory.new()

    for at in armor_types:
        full_dir = base_dir + at
        if dir.open(full_dir) == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while (file_name != ""):
                if dir.current_is_dir():
                    pass
                else:
                    if file_name.ends_with(".json"):
                        var file = File.new()
                        file.open(full_dir + "/" + file_name, file.READ)
                        var json = file.get_as_text()
                        var dict = Dictionary()
                        dict.parse_json(json)
                        var go = gear.new(at, dict)
                        items["armor"][go.name] = go
                        # print(dict)
                        # Create object to be held in items dict
                file_name = dir.get_next()
        else:
            print("Not able to open directory:", full_dir)

    for wt in weapon_types:
        full_dir = base_dir + wt
        if dir.open(full_dir) == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while (file_name != ""):
                if dir.current_is_dir():
                    pass
                else:
                    if file_name.ends_with(".json"):
                        var json = file_name.get_as_text()
                        var dict = Dictionary()
                        dict.parse_json(json)
                        var go = gear.new(wt, dict)
                        items["weapons"][go.name] = go
                        # Create object to be held in items dict
                file_name = dir.get_next()
        else:
            print("Not able to open directory:", full_dir)

    return items
