extends Node2D

func _ready():
    set_process(true)

func _process(delta):
    if Input.is_action_pressed("ui_exit"):
        get_tree().quit()
    if Input.is_action_pressed("ui_restart"):
        var currentScene = get_tree().get_current_scene().get_filename()
        get_tree().change_scene(currentScene)