extends Enemy
class_name Mothership

func destroy():
	death_sound.play()
	death_particles.emitting = true
	sprite.hide()
	set_collision_layer_value(4, false)
	await get_tree().create_timer(0.5).timeout
	on_killed.emit(score_modifier, true)
	queue_free()

func shoot():
	pass

func advance(_new_dir):
	pass

func _on_area_2d_body_entered(_body):
	queue_free()
	pass

func _randomize_timer():
	pass
