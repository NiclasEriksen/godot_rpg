
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var vel = Vector2(0, 0)
var oscillates = false
var osc_amount = 0
var lifetime = 0.0
var period = 1.0
var min_period_dist = 32
onready var initial_angle = get_rot()
onready var initial_pos = get_pos()
onready var trunk_pos = get_pos()
var target = Vector2(0, 0)
var max_time = 3.0
var dead = false
var spd = 0
var y = 0
onready var nc = get_node("/root/notifications")

func _ready():
	set_process(true)
	set_fixed_process(true)
	var dist = get_pos().distance_to(target)
	var dist_time = dist / spd
	if dist_time > max_time:
		dist_time = max_time
	else:
		max_time = dist_time
	if dist / 3 < min_period_dist:
		period = dist_time
	elif dist / 3 < min_period_dist * 2:
		period = dist_time / 2
	else:
		period = dist_time / 3

func _process(delta):
	if lifetime >= max_time and not dead:
		dead = true
		spd = 0
		oscillates = false
		get_node("AnimationPlayer").play("Explode")
	else:
		lifetime += delta
		if oscillates:
			# set_rot(initial_angle + PI * (lifetime / period) * osc_amount)
			oscillate()

	vel = Vector2(spd, 0).rotated(get_rot() + PI/2)

func _fixed_process(delta):
	set_pos(trunk_pos)
	move(vel * delta)
	trunk_pos = get_pos()
	set_pos(trunk_pos + Vector2(y, 0).rotated(get_rot()))

func set_velocity(speed):
	spd = speed

func set_target_pos(pos):
	target = pos

func oscillate():
	var x = PI * (lifetime / period)
	y = osc_amount * sin(x)
	var scale_amount = 1
	if y > 0:
		scale_amount = 1 + (abs(y) / abs(osc_amount)) / 5
	elif y < 0:
		scale_amount = 1 - (abs(y) / abs(osc_amount)) / 5
	get_node("Sprite").set_scale(Vector2(scale_amount, scale_amount))
	# print(sin(x), " - ", scale_amount)


func set_oscillation(amount):
	oscillates = true
	osc_amount = amount

func impact(body):
	if nc:
		nc.post_notification("explosion", null)
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	spd = 0
	oscillates = false
	get_node("AnimationPlayer").play("Explode")
	if body.is_in_group("enemies"):
		if body.get_node("StatsModule"):
			body.get_node("StatsModule").apply_effect(get_node("EffectModule"), null)

func _on_Area2D_body_enter( body ):
	if not body.is_in_group("players"):
		impact(body)

func _on_AnimationPlayer_finished():
	queue_free()
