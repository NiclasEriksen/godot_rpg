extends TextureProgress
var owner = null
onready var cam = get_tree().get_root().get_node("Game").get_node("Camera2D")
# onready var nc = get_node("/root/notifications")
var old_val = null

func _ready():
    set_process(true)

func register(owner):
    self.owner = weakref(owner)
    #print(self, owner, "HEEET")
    #set_value(owner.get("hp") / owner.get("max_hp") * 100.0)

func _process(delta):
    if owner.get_ref():
        var o = owner.get_ref()
        var pos = cam.get_viewport().get_canvas_transform().xform(o.get_pos())
        var val = (o.stats.get("hp") / o.stats.get("max_hp")) * 100.0
        set_pos(pos - (get_size() * get_scale()) / 2 - (Vector2(0, 10) / cam.get_zoom()))
        if not old_val == val:
            self.old_val = val
            set_value(val)
            get_node("AnimationPlayer").play("val_change")
    else:
        queue_free()
