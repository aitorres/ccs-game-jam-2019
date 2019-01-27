extends Control

var credits = [
	"CONCEPTUAL ART LEAD\nAndres Ignacio Torres",
	"PROGRAMMING LEAD\nChristian Oliveros",
	"MUSIC LEAD\nDavid Rodriguez",
	"ART LEAD\nAntonella Requena",
	"INSPIRED BY\nLOS DIAS ARQUEADOS\nWRITTEN BY\nLUIS EDUARDO BARRAZA",
	"FROM USB VE\nWITH LOVE",
	"Caracas Game Jam\n2019",
	"January 25 to\nJanuary 27\n2019",
	"THANKS\nFOR\nPLAYING!"
]

var counter = 0

func next_credit():
	if (counter < credits.size()):
		get_node("Text").set_text(credits[counter])
		counter += 1
	else:
		get_tree().quit()
