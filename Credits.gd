extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var credits = [
	"PROGRAMMING\nAndres Ignacio Torres\nChristian Oliveros",
	"MUSIC LEAD\nDavid Rodriguez",
	"DESIGN LEAD\nAntonella Requena",
	"FROM USB VE\nWITH LOVE",
	"Caracas Game Jam\n2019",
	"January 25 to\nJanuary 27\n2019",
	"THANKS\nFOR\nPLAYING"
]

var counter = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func next_credit():
	if (counter < credits.size()):
		get_node("Text").set_text(credits[counter])
		counter += 1
	else:
		get_tree().quit()
