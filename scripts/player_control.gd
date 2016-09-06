
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var jump_cd = false
signal moved(pos, rot)
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

# Actual game data
var max_hp = 10
var cur_hp = max_hp
var max_mp = 5
var cur_mp = max_mp

func _ready():
	set("cur_hp", get("max_hp") / 5)
	self.set_process(true)
	self.set_process_input(true)
	root = get_tree().get_root().get_node("Game")
	anim = get_node("BodyAnimation")

func apply_stat(effect, attr, amount):
	print("cur_" + attr)
	if get("cur_" + attr):
		if effect == "increase":
			if get("max_" + attr):
				var m = get("max_" + attr)
				if get("cur_" + attr) + amount < m:
					set("cur_" + attr, get("cur_" + attr) + amount)
				else:
					set("cur_" + attr, m)
			else:
				set("cur_" + attr, get("cur_" + attr) + amount)
		if effect == "decrease":
			set("cur_" + attr, get("cur_" + attr) - amount)


func _input(event):
	if event.is_action_pressed("MOVE_UP"):
		vel.y = vel.y + max_vel
	elif event.is_action_released("MOVE_UP"):
		vel.y = vel.y - max_vel
	if event.is_action_pressed("MOVE_DOWN"):
		vel.y = vel.y - max_vel
	elif event.is_action_released("MOVE_DOWN"):
		vel.y = vel.y + max_vel
	if event.is_action_pressed("MOVE_LEFT"):
		vel.x = vel.x + max_vel
	elif event.is_action_released("MOVE_LEFT"):
		vel.x = vel.x - max_vel
	if event.is_action_pressed("MOVE_RIGHT"):
		vel.x = vel.x - max_vel
	elif event.is_action_released("MOVE_RIGHT"):
		vel.x = vel.x + max_vel

func _process(delta):
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
		# self.move_and_slide(vel * 75 * delta)
		self.move(vel * 1.5 * delta)
	else:
		# print(vel.rotated(get_rot()), vel)
		# self.move_and_slide(vel * 50 * delta)
		self.move(vel.rotated(get_rot()) * delta)

	self.emit_signal("moved", get_pos(), get_rot())
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
	self.emit_signal("moved", get_pos(), get_rot())
