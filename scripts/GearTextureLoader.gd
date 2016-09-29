extends Node

var base_dir = "resources/equipment/"
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

func wear_gear(type, texture):
    pass

func get_texture(type, name):   # Loads and returns a texture
    pass

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
