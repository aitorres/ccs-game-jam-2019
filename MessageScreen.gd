extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(bool) var change_song = false
export var next_song = 1
export var next_scene = "res://WorkHereScene.tscn"

var credits = [
	"HOME IS NOT JUST A PLACE",
	"OR A PERSON\nOR A THING",
	"HOME IS WHERE YOU CAN\nFIND YOURSELF AT",
	"AND BE HAPPY"
]

var counter = 0
var next_exit = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _process(delta):
	if Input.is_action_pressed("ui_skip"):
		if not next_exit:
			next_exit = true
			counter = credits.size()
		else:
			get_tree().change_scene("res://Credits.tscn")

func next_credit():
	if (counter < credits.size()):
		get_node("Text").set_text(credits[counter])
		counter += 1
	else:
		if change_song:
			AudioManager.changeSong(next_song)
		get_tree().change_scene("res://Credits.tscn")
