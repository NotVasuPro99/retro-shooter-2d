extends Area2D

const SPEED = 200.0

@onready var explosion = $AnimatedSprite2D

var dying = false


func _process(delta):
	if dying:
		return

	position.y += SPEED * delta

	if position.y > 750:
		respawn()


func respawn():
	dying = false

	position.y = -50
	position.x = randf_range(50, 1100)

	# Turn the normal enemy back on
	$Sprite2D.visible = true

	# Hide explosion
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.stop()

	# Turn collision back on
	$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	if dying:
		return

	if body.name == "Player":
		body.play_hit_sound()
		body.play_hit_effect()

		var main_node = get_tree().current_scene

		if main_node.has_method("lose_life"):
			main_node.lose_life()

		respawn()


# Called by your bullet when it hits the enemy
func take_damage():
	# Stop enemy movement
	set_process(false)

	# Disable collision so more bullets/player can't hit it
	$CollisionShape2D.set_deferred("disabled", true)

	# Hide enemy
	$Sprite2D.visible = false

	# Show explosion
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("explode")

	# Wait for the animation to completely finish
	await $AnimatedSprite2D.animation_finished

	# Reset everything
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.visible = false
	$Sprite2D.visible = true

	$AnimatedSprite2D.frame = 0

	$CollisionShape2D.set_deferred("disabled", false)

	# Put enemy back at the top
	respawn()

	# Start enemy movement again
	set_process(true)
