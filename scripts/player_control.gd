
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var jump_cd = false
signal moved(pos)
signal jump
signal attack
var attacking = false
var sprinting = false
var vel = Vector2(0, 0)
var cur_vel = 0
var max_vel = 150
var sprint_factor = 1.5
var rot_spd = 5
var root = null
var anim = null

func _ready():
	self.set_process(true)
	self.set_process_input(true)
	root = get_tree().get_root().get_node("Game")
	anim = get_node("BodyAnimation")

func _draw():
	pass

func _input(event):
	if event.is_action_pressed("MOVE_UP"):
		vel.y = vel.y - max_vel
	elif event.is_action_released("MOVE_UP"):
		vel.y = vel.y + max_vel
	if event.is_action_pressed("MOVE_DOWN"):
		vel.y = vel.y + max_vel
	elif event.is_action_released("MOVE_DOWN"):
		vel.y = vel.y - max_vel
	if event.is_action_pressed("MOVE_LEFT"):
		vel.x = vel.x - max_vel
	elif event.is_action_released("MOVE_LEFT"):
		vel.x = vel.x + max_vel
	if event.is_action_pressed("MOVE_RIGHT"):
		vel.x = vel.x + max_vel
	elif event.is_action_released("MOVE_RIGHT"):
		vel.x = vel.x - max_vel

func _process(delta):
	# print(rand_range(0, 1))
	# vel = Vector2(0, 0)
	

	if Input.is_action_pressed("ATTACK"):
		if not attacking:
			emit_signal("attack")
			attacking = true
	else:
		attacking = false

	if Input.is_action_pressed("MOVE_JUMP"):
		self.jump()
	
	if root:
		var r = get_angle_to(root.get_global_mouse_pos()) * (rot_spd * delta)
		rotate(r)

	if Input.is_action_pressed("SPRINT"):
		self.move_and_slide(vel * 75 * delta)
	else:
		self.move_and_slide(vel * 50 * delta)

	self.emit_signal("moved", self.get_pos())
	if anim:
		if vel.x > 0.0 or vel.x < 0.0 or vel.y > 0.0 or vel.y < 0.0:
			if not anim.is_playing():
				anim.play("Walk")
			else:
				if Input.is_action_pressed("SPRINT"):
					anim.set_speed(sprint_factor)
				else:
					anim.set_speed(1)
				# print("Starting")
		else:
			if anim.is_playing():
				# print("Stopping")
				anim.stop(true)
		

func jump():
	self.emit_signal("jump")
	self.emit_signal("moved", self.get_pos())
