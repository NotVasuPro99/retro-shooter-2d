extends Control

# The % sign tells Godot to find this unique node anywhere in the scene instantly
@onready var play_button = %PlayButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
