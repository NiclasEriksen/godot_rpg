
extends KinematicBody2D

var fireball = load("res://entities/projectiles/Fireball.tscn")
var spd = 160
var target = Vector2(0, 0)

func _ready():
	set_fixed_process(true)
	var l_ball = fireball.instance()
	l_ball.set_pos(get_pos())
	l_ball.set_rot(get_rot())
	l_ball.set_velocity(spd)
	l_ball.set_oscillation(-12)
	l_ball.set_target_pos(target)
	var r_ball = fireball.instance()
	r_ball.set_pos(get_pos())
	r_ball.set_rot(get_rot())
	r_ball.set_velocity(spd)
	r_ball.set_oscillation(12)
	r_ball.set_target_pos(target)
	var cl_ball = fireball.instance()
	cl_ball.set_pos(get_pos())
	cl_ball.set_rot(get_rot())
	cl_ball.set_velocity(spd)
	cl_ball.set_oscillation(-24)
	cl_ball.set_target_pos(target)
	var cr_ball = fireball.instance()
	cr_ball.set_pos(get_pos())
	cr_ball.set_rot(get_rot())
	cr_ball.set_velocity(spd)
	cr_ball.set_oscillation(24)
	cr_ball.set_target_pos(target)
	var c_ball = fireball.instance()
	c_ball.set_pos(get_pos())
	c_ball.set_rot(get_rot())
	c_ball.set_velocity(spd)
	c_ball.set_oscillation(0)
	c_ball.set_target_pos(target)
	get_parent().add_child(l_ball)
	get_parent().add_child(r_ball)
	get_parent().add_child(cl_ball)
	get_parent().add_child(cr_ball)
	get_parent().add_child(c_ball)
	queue_free()


func set_target_pos(pos):
	target = pos
