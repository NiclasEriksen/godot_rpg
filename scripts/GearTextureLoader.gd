extends Node

var base_dir = "resources/equipment/"
var debug_tex = base_dir + "debug.png"
var valid_types = ["chest", "head", "hands"]
onready var owner = get_parent()
var body = {
    torso="Torso/ChestArmor",
    head="Torso/HeadArmor",
    shoulder_left="Torso/LeftShoulder/ShoulderArmor",
    shoulder_right="Torso/RightShoulder/ShoulderArmor",
    arm_left="Torso/LeftShoulder/LeftArm/ArmArmor",
    arm_right="Torso/RightShoulder/RightArm/ArmArmor",
    hand_left="Torso/LeftShoulder/LeftArm/LeftHand/HandArmor",
    hand_right="Torso/RightShoulder/RightArm/RightHand/HandArmor"
}

func _ready():
    pass
    # print(generate_list("chest"))

func wear_gear(target, type, texture):
    if type == "chest":
        var t = target.get_node(body["torso"])
        var sl = target.get_node(body["shoulder_left"])
        var sr = target.get_node(body["shoulder_right"])
        var al = target.get_node(body["arm_left"])
        var ar = target.get_node(body["arm_right"])
        t.set_texture(texture)
        sl.set_texture(texture)
        sr.set_texture(texture)
        al.set_texture(texture)
        ar.set_texture(texture)
        t.set_region(true)
        t.set_region_rect(Rect2(0, 0, 32, 32))
        sl.set_region(true)
        sl.set_region_rect(Rect2(32, 0, 32, 32))
        sr.set_region(true)
        sr.set_region_rect(Rect2(32, 0, 32, 32))
        al.set_region(true)
        al.set_region_rect(Rect2(64, 0, 32, 32))
        ar.set_region(true)
        ar.set_region_rect(Rect2(64, 0, 32, 32))
    elif type == "head":
        target.get_node(body["head"]).set_texture(texture)
    elif type == "hands":
        target.get_node(body["hand_left"]).set_texture(texture)
        target.get_node(body["hand_right"]).set_texture(texture)


func get_texture(type, name):   # Loads and returns a texture
    var file = File.new()
    var full_path = base_dir + type + "/" + name + ".png"
    if file.file_exists(full_path):
        return load(full_path)
    else:
        return load(debug_tex)

func generate_list(type):
    var dir = Directory.new()
    var textures = []
    var full_dir = ""
    if type in valid_types:
        full_dir = base_dir + type
    else:
        print("Don't know that type: \"" + type + "\". Returning empty list.")
        return textures
    if dir.open(full_dir) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while (file_name != ""):
            if dir.current_is_dir():
                pass
            else:
                if file_name.ends_with(".png"):
                    textures.append(file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")

    return textures
