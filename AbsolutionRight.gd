extends Container

export(bool) var change_song = false
export var next_song = 1
export var next_scene = "res://Credits.tscn"
export var poem_container_path = "KinematicBody2D/textbox/Container/Background/poem"

func _mostrar_mensaje(mensaje):
	get_node(poem_container_path).longText = mensaje
	get_node(poem_container_path).reset_config()
	get_node(poem_container_path).reset_text(true)

func _on_try_to_leave(body):
	if not (body is StaticBody2D):
		get_node(poem_container_path).longText = "time to go back to myself."
		get_node(poem_container_path).reset_config()
		get_node(poem_container_path).reset_text(true)
		yield(get_tree().create_timer(6), "timeout")
		if change_song:
			AudioManager.changeSong(next_song)
		AudioManager.playDoorSound()
		get_tree().change_scene(next_scene)

func _call_mostrar_mensaje(body, mensaje):
	if not (body is StaticBody2D):
		_mostrar_mensaje(
			mensaje
		)
		
func he_creado_siete_putas_funciones_iguales___como_crees_que_se_llama_esta(body):
	_call_mostrar_mensaje(
		body,
		"things may seem shallow in the darkest of days"
	)
	
func sixth_area(body):
	_call_mostrar_mensaje(
		body,
		"but there is always a light, big or small"
	)


func fifth_area(body):
	_call_mostrar_mensaje(
		body,
		"a fierce strength that comes from within youself"
	)


func fourth_area(body):
	_call_mostrar_mensaje(
		body,
		"and helps you through every battle, no matter how hard"
	)

func third_area(body):
	_call_mostrar_mensaje(
		body,
		"this will surely be a difficult journey"
	)

func second_area(body):
	_call_mostrar_mensaje(
		body,
		"but a great one nonetheless"
	)

func first_area(body):
	_call_mostrar_mensaje(
		body,
		"and it is finally time"
	)
