extends Node2D

var score = 0
var lives = 3

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var lives_label = $CanvasLayer/LivesLabel
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var death_sound = $CanvasLayer/GameOverScreen/DeathSound
@onready var camera = $Camera2D

func _ready():
	# Hide screen at start
	game_over_screen.visible = false
	
	# Force stop the sound if it started automatically
	if death_sound.playing:
		death_sound.stop()

func trigger_game_over():
	print("Game Over Triggered!")
	game_over_screen.show_game_over(score)
	get_tree().paused = true

func add_score():
	score += 1
	score_label.text = "Score: " + str(score)

func lose_life():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	
	if lives <= 0:
		trigger_game_over() # Pause the game when dead

func screen_shake():
	var camera = $Camera2D
	var original_position = camera.position
	
	for i in range(8):
		camera.position = original_position + Vector2(
			randf_range(-8, 8),
			randf_range(-8, 8)
		)
		await get_tree().create_timer(0.02).timeout
	
	camera.position = original_position
