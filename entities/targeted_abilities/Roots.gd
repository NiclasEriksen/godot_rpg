
extends Node2D

var lifetime = 0.0
var max_time = 2.0
var grown = false
var attached = false

func _ready():
	set_process(true)
	get_node("AnimationPlayer").play("Grow")
	print("Growing")

func _process(delta):
	if not grown:
		lifetime += delta
		if lifetime >= max_time:
			get_node("Area2D").call_deferred("set_enable_monitoring", false)
			get_node("AnimationPlayer").play("Shrink")
			grown = true

func kill():
	if not attached:
		queue_free()

func impact(body):
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	#get_node("AnimationPlayer").play("Explode")
	attached = true
	if body.get_node("StatsModule"):
		body.set_pos(get_pos())
		get_node("StunModule").buff_time = max_time - lifetime
		get_node("EffectModule").buff_time = max_time - lifetime
		body.get_node("StatsModule").apply_effect(get_node("StunModule"), null)
		body.get_node("StatsModule").apply_effect(get_node("EffectModule"), null)
		print("ANAMAI DEIMEIGED!")

func _on_Area2D_body_enter(body):
	if body.is_in_group("players"):
		impact(body)
