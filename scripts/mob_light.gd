extends Light2D

const Simplex = preload("simplex.gd") # Relative path
onready var simplex = Simplex.new()

var oct = 5
var freq = 3
var noise_z = 50
var max_offset = 3
var intensity_variation = 0.25

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)


func translate(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    var leftSpan = leftMax - leftMin
    var rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    var valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)

func _process(delta):
	#print("Lol")
	# var cur = self.get_pos()
	var ox = simplex.simplex2(0, noise_z)
	var oy = simplex.simplex2(0, noise_z - 10)
	# var intensity = simplex.simplex2(0, noise_z + 10)
	# var oy = cur.y
	ox = translate(ox, -1.5, 1.5, -max_offset, max_offset)
	oy = translate(oy, -1.5, 1.5, -max_offset, max_offset)
	noise_z += 0.02
	# var ox = rand_range(-2, 2)
	# var oy = rand_range(-2, 2)
	# print(intensity)
	# self.set_energy(1 + intensity * intensity_variation)
	set_texture_offset(Vector2(ox, oy))
