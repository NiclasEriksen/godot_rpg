
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

func impact():
	vel = Vector2(0, 0)
	get_node("AnimationPlayer").play("Explode")

func _on_Area2D_body_enter( body ):
	if not body.is_in_group("players"):
		impact()


func _on_AnimationPlayer_finished():
	queue_free()
