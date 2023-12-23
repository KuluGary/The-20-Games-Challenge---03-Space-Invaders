extends Area2D
class_name Bullet

var dir = Vector2.UP
var speed = 2
var group: String

func _physics_process(_delta):
	global_position += dir * speed

func _on_area_entered(area):
	if not area is Bullet or (area is Bullet and area.group != group): 
		queue_free()

func _on_body_entered(body):
	if not body.is_in_group(group):
		body.destroy()
		queue_free()
