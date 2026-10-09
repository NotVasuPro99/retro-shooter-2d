extends Control

# Nodes references
@onready var story_scene_1 = $StoryScene1
@onready var story_scene_2 = $StoryScene2

# Signals to notify your main game controller when story sequence ends
signal story_completed

func _ready():
	# Start by showing Scene 1 and hiding Scene 2
	story_scene_1.visible = true
	story_scene_2.visible = false

# Triggered when "CONTINUE" is pressed on Story 1
func _on_story_1_continue_button_pressed():
	story_scene_1.visible = false
	story_scene_2.visible = true

# Triggered when "CONTINUE" is pressed on Story 2
func _on_story_2_continue_button_pressed():
	story_scene_2.visible = false
	emit_signal("story_completed") # Transition to main game
