extends TextureProgress
var owner = null
onready var cam = get_tree().get_root().get_node("Game").get_node("Camera2D")
# onready var nc = get_node("/root/notifications")

func _ready():
    set_process(true)

func register(owner):
    self.owner = owner
    print(self, owner, "HEEET")
    #set_value(owner.get("hp") / owner.get("max_hp") * 100.0)

func _process(delta):
    if owner:
        var pos = cam.get_viewport().get_canvas_transform().xform(owner.get_pos())
        set_pos(pos - (get_size() * get_scale()) / 2 - Vector2(0, 50))
        set_value((owner.stats.get("hp") / owner.stats.get("max_hp")) * 100.0)
