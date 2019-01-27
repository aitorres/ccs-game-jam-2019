extends Control

var music = [
    preload("res://assets/music/baja-1.ogg"),
    preload("res://assets/music/Intermedio.ogg"),
    preload("res://assets/music/baja-incertidumbre.ogg")
]

var currSong = 0

export(float, 0, 5, 0.00001) var fadeTime = 0.001
var accTime = 0.0

var samplers = []
var samplersVol = [0.0, 0.0]
var currSampler = 0
var prevSampler = 0
var prevVol = 0.0

var MIN_VOL = -80.0
var MAX_VOL = 0

var initial_fadein = false
var init_crossfade = false

func _ready():
    var sampler1 = AudioStreamPlayer.new()
    add_child(sampler1)
    sampler1.volume_db = MIN_VOL

    var sampler2 = AudioStreamPlayer.new()
    add_child(sampler2)
    sampler2.volume_db = MIN_VOL

    samplers = [sampler1, sampler2]
    samplersVol = [0.0, 0.0]
    
    currSong = 0
    currSampler = 0
    prevSampler = 0

    samplers[currSampler].stream = music[currSong]
    samplers[currSampler].play()

    initial_fadein = true
    accTime = 0.0


func lerpSampler(sampID, vol):
    samplers[sampID].volume_db = lerp(MIN_VOL, MAX_VOL, vol)
    samplersVol[sampID] = vol

func crossFadeSamplers(sampID, vol):
    lerpSampler(sampID, vol)
    if sampID + 1 >= samplers.size():
        lerpSampler(0, 1.0 - vol)
    else:
        lerpSampler(sampID, 1.0 - vol)


    
func _process(delta):
    if initial_fadein && !init_crossfade:
        if accTime <= fadeTime:
            accTime += delta
            lerpSampler(currSampler, clamp(accTime/fadeTime, 0.0, 1.0))
        else:
            initial_fadein = false
            accTime = 0.0
    elif init_crossfade && !initial_fadein:
        if accTime <= fadeTime:
            accTime += delta
            crossFadeSamplers(currSampler, clamp(accTime/fadeTime, 0.0, 1.0))
        else:
            init_crossfade = false
            samplers[prevSampler].stop()
            accTime = 0.0
    elif init_crossfade && initial_fadein:
        if accTime <= fadeTime:
            accTime += delta
            var w = clamp(accTime/fadeTime, 0.0, 1.0)
            if w < prevVol:
                lerpSampler(currSampler, w)
            else:
                crossFadeSamplers(currSampler, w)
        else:
            init_crossfade = false
            initial_fadein = false
            samplers[prevSampler].stop()
            accTime = 0.0

func changeSong(song):
    currSong = song % music.size()
    prevSampler = currSampler
    currSampler = (currSampler + 1) % samplers.size()
    samplers[currSampler].stream = music[currSong]
    samplers[currSampler].play()

    if init_crossfade || initial_fadein:
        prevVol = 1.0 - samplersVol[prevSampler]
        initial_fadein = true

    init_crossfade = true
