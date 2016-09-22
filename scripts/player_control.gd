
extends Node2D

var jump_cd = false
signal moved(pos, rot)
signal stopped
signal jump
signal attack
onready var stats = get_node("StatsModule")
var fireball = load("res://entities/projectiles/TripleFireBall.tscn")
var roots = load("res://entities/targeted_abilities/Roots.tscn")
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
var already_stopped = false

func _ready():
	set_process(true)
	set_process_input(true)
	root = get_tree().get_root().get_node("Game")
	var spawn = get_tree().get_root().get_node("Game").get_node("Nav").get_node("Map").get_node("SpawnPoint")
	if spawn:
		self.set_pos(spawn.get_pos())
	emit_signal("moved", get_pos(), get_rot())


func _input(event):
	if get_node("StatsModule"):
		max_vel = get_node("StatsModule").get_actual("movement_speed")
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
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			event = root.make_input_local(event)
			var ol = root.get_node("ObjectLayer")
			var r = roots.instance()
			#r.set_pos(event.pos)
			r.set_pos(event.pos)
			ol.add_child(r)


func _process(delta):
	# var r = get_rot()
	if Input.is_action_pressed("ATTACK"):
		if not attacking:
			emit_signal("attack")
			var ol = root.get_node("ObjectLayer")
			var fbi = fireball.instance()
			fbi.set_rot(get_rot())
			fbi.set_pos(get_pos())
			#fbi.set_velocity(300)
			ol.add_child(fbi)

			# get_node("StatsModule").apply_effect([["mp", -1]], null)
			attacking = true
	else:
		attacking = false


	if vel.x or vel.y:
		already_stopped = false
		emit_signal("moved", get_pos(), get_rot())
	elif not already_stopped:
		already_stopped = true
		emit_signal("stopped")

	var motion = vel * delta
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		# vel = n.slide(vel)
		move(motion)

	var r = 0
	if root:
		r = get_angle_to(root.get_global_mouse_pos()) * (rot_spd * delta)
		rotate(r)


func jump():
	self.emit_signal("jump")
	self.emit_signal("moved", get_pos(), get_rot())


func _on_CanvasModulate_nightmode( state ):
	get_node("Light2D1").set_hidden(not state)
