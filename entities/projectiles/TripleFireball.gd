
extends KinematicBody2D

var fireball = load("res://entities/projectiles/Fireball.tscn")
var spd = 200

func _ready():
	set_fixed_process(true)
	var l_ball = fireball.instance()
	l_ball.set_pos(get_pos())
	l_ball.set_rot(get_rot() + PI/6)
	l_ball.set_velocity(spd)
	l_ball.set_oscillation(-0.3)
	var r_ball = fireball.instance()
	r_ball.set_pos(get_pos())
	r_ball.set_rot(get_rot() - PI/6)
	r_ball.set_velocity(spd)
	r_ball.set_oscillation(0.3)
	var c_ball = fireball.instance()
	c_ball.set_pos(get_pos())
	c_ball.set_rot(get_rot())
	c_ball.set_velocity(spd)
	get_parent().add_child(l_ball)
	get_parent().add_child(r_ball)
	get_parent().add_child(c_ball)
	queue_free()

