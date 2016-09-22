
extends Node2D

var lifetime = 0.0
var max_time = 5.0

func _ready():
	set_process(true)
	get_node("AnimationPlayer").play("Grow")
	print("Growing")

func _process(delta):
	lifetime += delta
	if lifetime >= max_time:
		print("Dying!")
		queue_free()

func impact(body):
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	#get_node("AnimationPlayer").play("Explode")
	if body.get_node("StatsModule"):
		body.get_node("StatsModule").apply_effect(get_node("EffectModule"), null)
		print("ANAMAI DEIMEIGED!")

func _on_Area2D_body_enter(body):
	if body.is_in_group("enemies"):
		impact(body)
