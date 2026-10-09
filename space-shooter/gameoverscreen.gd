extends Control

@onready var death_sound = $DeathSound
@onready var restart_button = %RestartButton
@onready var score_label = $ScoreLabel
@onready var comment_label = $CommentLabel

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)

func show_game_over(score):
	visible = true
	score_label.text = "SCORE: " + str(score)
	
	if score < 20:
		comment_label.text = "KEEP TRYING!"
	elif score < 50:
		comment_label.text = "NICE RUN!"
	elif score < 100:
		comment_label.text = "PRETTY DECENT!"
	elif score < 200:
		comment_label.text = "WHOA! GOOD SCORE!"
	else:
		comment_label.text = "ABSOLUTE LEGEND!"

	if death_sound:
		death_sound.play()

func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_select"):
		_on_restart_pressed()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
