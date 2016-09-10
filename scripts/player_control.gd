
extends Node2D

var jump_cd = false
signal moved(pos, rot)
signal stopped
signal jump
signal attack
onready var stats = get_node("StatsModule")
var attacking = false
var sprinting = false
var last_pos = null
var moving = false
var vel = Vector2(0, 0)
var cur_vel = 0
export(int) var max_vel = 100
var sprint_factor = 1.5
var rot_spd = 3
var root = null
var anim = null


func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	root = get_tree().get_root().get_node("Game")


func _input(event):
	if get_node("StatsModule"):
		max_vel = get_node("StatsModule").get("movement_speed")
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
		# set_rot(get_rot() - 0.01)
	elif event.is_action_released("MOVE_LEFT"):
		vel.x = vel.x + max_vel
	if event.is_action_pressed("MOVE_RIGHT"):
		vel.x = vel.x + max_vel
		# set_rot(get_rot() + 0.01)
	elif event.is_action_released("MOVE_RIGHT"):
		vel.x = vel.x - max_vel

func _process(delta):
	# var r = get_rot()
	if Input.is_action_pressed("ATTACK"):
		if not attacking:
			emit_signal("attack")
			# get_node("StatsModule").apply_effect([["mp", -1]], null)
			attacking = true
	else:
		attacking = false

	if Input.is_action_pressed("MOVE_JUMP"):
		self.jump()

	var r = 0

	if root:
		r = get_angle_to(root.get_global_mouse_pos()) * (rot_spd * delta)
		rotate(r)
		# if Input.is_action_pressed("MOUSE_ROTATE"):
		# 	r = get_angle_to(root.get_global_mouse_pos()) * (rot_spd * delta)
		#	if Input.is_action_pressed("MOVE_LEFT"):
		#		vel.x = max_vel
		#	elif Input.is_action_pressed("MOVE_RIGHT"):
		#		vel.x = -max_vel
		#else:
		#	if Input.is_action_pressed("MOVE_LEFT"):
		#		rotate(rot_spd * delta)
		#	if Input.is_action_pressed("MOVE_RIGHT"):
		#		rotate(-(rot_spd * delta))
		# print(vel.rotated(get_rot()), vel)
		# self.move_and_slide(vel * 50 * delta)
		# self.move(vel.rotated(get_rot()) * delta)
		var motion = vel * delta
		motion = move(motion)
		if (is_colliding()):
        	var n = get_collision_normal()
        	motion = n.slide(motion)
        	# vel = n.slide(vel)
        	move(motion)


func _fixed_process(delta):
	if not get_pos() == last_pos:
		emit_signal("moved", get_pos(), get_rot())
	else:
		emit_signal("stopped")
	last_pos = get_pos()



func jump():
	self.emit_signal("jump")
	self.emit_signal("moved", get_pos(), get_rot())
