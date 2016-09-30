var base_dir = "game_objects/equipment/"
var gear_types = ["chest", "head", "hands"]
var weapon_types = ["sword", "mace", "staff", "bow", "dagger"]

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
                        var json = file_name.get_as_text()
                        var dict = Dictionary()
                        dict.parse_json(json)
                        print(dict)
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
                            print(dict)
                            # Create object to be held in items dict
                    file_name = dir.get_next()
            else:
                print("Not able to open directory:", full_dir)
