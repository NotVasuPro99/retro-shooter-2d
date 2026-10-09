extends Area2D

const SPEED = 800.0

func _physics_process(delta):
	position.y -= SPEED * delta
	
	# Scan directly for overlapping enemies every frame
	for area in get_overlapping_areas():
		if area.name.begins_with("Enemy") or area.name.begins_with("enemy"):
			
			# Find the main scene and increase the score
			var main_node = get_tree().current_scene
			if main_node.has_method("add_score"):
				main_node.add_score()
			
			area.take_damage()  # Reset the enemy back to the top
			queue_free()   # Destroy the bullet

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
