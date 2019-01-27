extends Node

func _ready():
    set_process(true)
    var player = AudioStreamPlayer.new()
    self.add_child(player)
    var stream = AudioStreamSample.new()
    stream.resource_path = "res://assets/music/wind_1.wav"
    stream.loop_mode = 1
    print(stream)
    player.stream = stream
    player.play()

func _process():
    print("Hola")