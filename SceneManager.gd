extends Container

export(bool) var change_song = false
export var next_song = 1
export var next_scene = "res://ParkScene.tscn"
export var poem_container_path = "textbox/Container/Background/poem"
export(bool) var use_final_text = true
export(String, MULTILINE) var longText = "time to go back and shine like a star"

var fade_out_time = 2.0

var final_text = false

var fade_node = null

func _ready():
	var scene = preload("res://FadeControl.tscn") # Will load when parsing the script.
	fade_node = scene.instance()
	add_child(fade_node)

func _on_try_to_leave(body):
	if not (body is StaticBody2D):
		if get_node(poem_container_path).done:

			if use_final_text && !final_text:
				get_node(poem_container_path).longText = longText
				get_node(poem_container_path).reset_config()
				get_node(poem_container_path).reset_text(true)
				final_text = true
				print("Final Texting")
			else:
				fadeOut()

func fadeOut():
	print("Fading Out")
	fade_node.get_node("AnimationPlayer").play("FadeOut")
	if change_song:
		AudioManager.changeSong(next_song)
	yield(get_tree().create_timer(fade_out_time), "timeout")
	get_tree().change_scene(next_scene)

			
func _process(delta):
	if use_final_text && final_text && get_node(poem_container_path).done:
		use_final_text = false
		fadeOut()