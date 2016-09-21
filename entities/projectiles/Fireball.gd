
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var vel = Vector2(0, 0)


func _ready():
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	pass

func _fixed_process(delta):
	move(vel * delta)

func set_velocity(speed):
	vel = Vector2(speed, 0).rotated(get_rot() - PI/2)

func impact(body):
	get_node("Area2D").call_deferred("set_enable_monitoring", false)
	vel = Vector2(0, 0)
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
