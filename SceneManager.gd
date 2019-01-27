extends Container

export(bool) var change_song = false
export var next_song = 1
export var next_scene = "res://Credits.tscn"
export var poem_container_path = "textbox/Container/Background/poem"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if get_node(poem_container_path).done:
		if change_song:
			AudioManager.changeSong(next_song)
		get_tree().change_scene(next_scene)
