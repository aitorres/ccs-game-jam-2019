extends KinematicBody2D

export (bool) var can_move = true
export (int) var speed = 200

var velocity = Vector2()

func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    velocity.y = 0
    velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    if can_move:
        move_and_slide(velocity)