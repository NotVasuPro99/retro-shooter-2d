extends CharacterBody2D

const SPEED = 600.0
const TILT_ANGLE = 8.0
const TILT_SPEED = 10.0

var bullet_scene = preload("res://bullet.tscn")

@onready var shoot_sound = $AudioStreamPlayer2D
@onready var hit_sound = $HitSound
@onready var muzzle_flash = $Muzzle/MuzzleFlash


func _physics_process(delta):
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED
	
	move_and_slide()
	
	# Keep player on screen
	position.x = clamp(position.x, 50, 1150)
	position.y = clamp(position.y, 50, 650)
	
	# Smoothly tilt the ship while moving left/right
	var target_rotation = deg_to_rad(direction_x * TILT_ANGLE)
	rotation = lerp(rotation, target_rotation, TILT_SPEED * delta)
	
	# Shoot on Spacebar
	if Input.is_action_just_pressed("ui_accept"):
		shoot()


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Muzzle.global_position
	get_tree().root.add_child(bullet)
	
	if shoot_sound:
		shoot_sound.play()
	
	muzzle_flash.visible = true
	
	await get_tree().create_timer(0.05).timeout
	
	muzzle_flash.visible = false

func play_hit_effect():
	# YOUR HIT EFFECT GOES HERE
	print("PLAYER HIT EFFECT CALLED")
	var tween = create_tween()
	
	tween.tween_property($Sprite2D, "modulate", Color(1, 0.2, 0.2), 0.08)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.08)
	
	var main_node = get_tree().current_scene
	if main_node.has_method("screen_shake"):
		main_node.screen_shake()


func play_hit_sound():
	print("🔊 PLAY HIT SOUND CALLED")
	
	if hit_sound:
		hit_sound.play()


func _on_hitbox_body_entered(body):
	if body.name == "Enemy":
		print("GAME OVER!")
		print("Player hit by enemy!")
		
		if get_tree().current_scene.has_method("trigger_game_over"):
			get_tree().current_scene.trigger_game_over()
		
		get_tree().change_scene_to_file("res://game_over_screen.tscn")
