extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var credits = [
	"\"ONE IS BUT A THING",
	"AT THIS TIMELY\nVAGUENESS OF THE DAY,",
	"WHAT REMAINS\nOF ONE'S IMAGE,",
	"ALMOST DISTANT",
	"LEFT BEHIND\nMANY HOMES AGO",
	"FAR AWAY\nWITHIN A STARE\"",
	"- LUIS EDUARDO BARRAZA\n2017",
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
			get_tree().change_scene("res://WorkHereScene.tscn")

func next_credit():
	if (counter < credits.size()):
		get_node("Text").set_text(credits[counter])
		counter += 1
	else:
		get_tree().change_scene("res://WorkHereScene.tscn")
