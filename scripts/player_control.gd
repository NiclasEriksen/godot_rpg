
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var jump_cd = false
signal moved(pos)
signal jump
var vel = Vector2(0, 0)
var cur_vel = 0
var max_vel = 150
var sprint_factor = 1.5
var rot_spd = 5
var root = null

func _ready():
	self.set_process(true)
	self.set_process_input(true)
	var root = get_tree().get_root().get_node("Game")
	# var c = get_node("Camera2D")
	# if c:
	# 	c.set_pos(get_pos())
	# connect("moved", self, "Camera2D")
	# var cam = get_node("Camera2D")
	# cam.connect("moved", self, "sprite_moved")

func _draw():
	pass
		# var pos = Vector2(self.get_parent().get_rect().size.width/2, self.get_parent().get_rect().size.height/2)

func _input(event):
	pass

func _process(delta):
	# print(rand_range(0, 1))
	vel = Vector2(0, 0)
	cur_vel = max_vel
	
	if Input.is_action_pressed("SPRINT"):
		print("Sprint!")
		cur_vel = max_vel * sprint_factor
	else:
		cur_vel = max_vel

	print(cur_vel, max_vel)

	if Input.is_action_pressed("MOVE_UP") and Input.is_action_pressed("MOVE_DOWN"):
		vel.y = 0
	elif Input.is_action_pressed("MOVE_UP"):
		vel.y = -cur_vel
	elif Input.is_action_pressed("MOVE_DOWN"):
		vel.y = cur_vel
	else:
		vel.y = 0
	if Input.is_action_pressed("MOVE_LEFT") and Input.is_action_pressed("MOVE_RIGHT"):
		vel.x = 0
	elif Input.is_action_pressed("MOVE_LEFT"):
		vel.x = -cur_vel
	elif Input.is_action_pressed("MOVE_RIGHT"):
		vel.x = cur_vel
	else:
		vel.x = 0

	if Input.is_action_pressed("MOVE_JUMP"):
		self.jump()
	
	if root:
		var r = get_angle_to(root.get_global_mouse_pos()) * (rot_spd * delta)
		rotate(r)
	else:
		root = get_tree().get_root().get_node("Game")

	self.move_and_slide(vel * 50 * delta)

	self.emit_signal("moved", self.get_pos())
	var anim = get_node("Sprite 2/AnimationPlayer")
	if anim:
		if not anim.is_active():
			# print("Not active.")
			anim.set_active(true)
		if vel.x > 0.0 or vel.x < 0.0 or vel.y > 0.0 or vel.y < 0.0:
			if not anim.is_playing():
				anim.play("Walk")
				# print("Starting")
		else:
			if anim.is_playing():
				# print("Stopping")
				anim.stop()
		

func jump():
	self.emit_signal("jump")
	self.emit_signal("moved", self.get_pos())
