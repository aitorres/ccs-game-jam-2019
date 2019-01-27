extends Container

export(bool) var change_song = false
export var next_song = 1
export var next_scene = "res://ParkScene.tscn"
export var poem_container_path = "textbox/Container/Background/poem"

func _on_try_to_leave(body):
	if not (body is StaticBody2D):
		if get_node(poem_container_path).done:
			get_node(poem_container_path).longText = "time to go back and shine like a star"
			get_node(poem_container_path).reset_config()
			get_node(poem_container_path).reset_text(true)
			yield(get_tree().create_timer(6), "timeout")
			if change_song:
				AudioManager.changeSong(next_song)
			get_tree().change_scene(next_scene)

func hola(body):
	if not (body is StaticBody2D):
		get_node(poem_container_path).reset_text(true)


func salir(body):
	if not (body is StaticBody2D):
		if get_node(poem_container_path).done:
			get_node(poem_container_path).longText = "time to go back and shine like a star"
			get_node(poem_container_path).reset_config()
			get_node(poem_container_path).reset_text(true)
			yield(get_tree().create_timer(6), "timeout")
			if change_song:
				AudioManager.changeSong(next_song)
			get_tree().change_scene(next_scene)
