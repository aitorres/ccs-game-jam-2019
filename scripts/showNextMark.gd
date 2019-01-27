extends Area2D

export(bool) var startActive = false
export(NodePath) var nextMark
export(NodePath) var poemPath

var checking = false
var waiting = false

var poemNode = null

func _ready():
	poemNode = get_node(poemPath)
	checking = startActive
	if startActive:
		show()
	else:
		hide()


func _process(delta):
	if waiting && poemNode.done:
		waiting = false
		checking = false
		hide()
		if nextMark:
			get_node(nextMark).startChecking()

func startChecking():
	checking = true
	show()

func _on_Area2D_body_entered(body):
	if checking && not (body is StaticBody2D):
		waiting = true
		
		