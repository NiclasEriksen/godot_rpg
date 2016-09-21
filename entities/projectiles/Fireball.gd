
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var vel = Vector2(0, 0)
var oscillates = false
var osc_amount = 0
var lifetime = 0.0
var period = 1.0
var initial_angle = 0
var max_time = 3.0
var spd = 0

func _ready():
	set_process(true)
	set_fixed_process(true)
	initial_angle = get_rot()

func _process(delta):
	if lifetime >= max_time:
		queue_free()
	else:
		lifetime += delta
		if oscillates:
			set_rot(initial_angle + PI * (lifetime / period) * osc_amount)
		vel = Vector2(spd, 0).rotated(get_rot() - PI/2)

func _fixed_process(delta):
	move(vel * delta)

func set_velocity(speed):
	spd = speed

func set_oscillation(amount):
	oscillates = true
	osc_amount = amount

func impact(body):
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	spd = 0
	get_node("AnimationPlayer").play("Explode")
	if body.is_in_group("enemies"):
		if body.get_node("StatsModule"):
			body.get_node("StatsModule").apply_effect(get_node("EffectModule"), null)
			print("ANAMAI!")

func _on_Area2D_body_enter( body ):
	if not body.is_in_group("players"):
		impact(body)

func _on_AnimationPlayer_finished():
	queue_free()
