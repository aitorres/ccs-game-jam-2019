extends Control

var music = [
    preload("res://assets/music/baja-1.ogg"),
    preload("res://assets/music/Intermedio.ogg"),
    preload("res://assets/music/alta-2.ogg"),
    preload("res://assets/music/baja-incertidumbre.ogg"),
    preload("res://assets/music/alta-final.ogg"),
]

var sfx_door = preload("res://assets/sfx/431117__inspectorj__door-front-opening-a.wav")

var currSong = 0

export(float, 0, 5, 0.00001) var fadeTime = 3
var accTime = 0.0

var samplers = []
var samplersVol = [0.0, 0.0]
var currSampler = 0
var prevSampler = 0
var prevVol = 0.0

var sfx_sampler = null

var MIN_VOL = -80.0
var MAX_VOL = 0

var initial_fadein = false
var init_crossfade = false

func _ready():

    for song in music:
        song.set_loop(true) 

    sfx_sampler = AudioStreamPlayer.new()
    add_child(sfx_sampler)
    sfx_sampler.volume_db = MAX_VOL
    sfx_sampler.stream = sfx_door

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
        #print(String(sampID) + " a " + String(vol) + " " + String(0) + " " + String(1.0 - vol))
    else:
        lerpSampler(sampID + 1, 1.0 - vol)
        #print(String(sampID) + " a " + String(vol) + " " + String(sampID + 1) + " " + String(1.0 - vol))



    
func _process(delta):
    if initial_fadein && !init_crossfade:
        if accTime <= fadeTime:
            accTime += delta
            lerpSampler(currSampler, clamp(accTime/fadeTime, 0.0, 1.0))
        else:
            print("Initial Fade In Done")
            lerpSampler(currSampler, 1.0)
            initial_fadein = false
            accTime = 0.0
    elif init_crossfade && !initial_fadein:
        if accTime <= fadeTime:
            accTime += delta
            crossFadeSamplers(currSampler, clamp(accTime/fadeTime, 0.0, 1.0))
        else:
            print("Cross Fade Done")
            lerpSampler(currSampler, 1.0)
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
            print("Half Cross Fade Done")
            lerpSampler(currSampler, 1.0)
            init_crossfade = false
            initial_fadein = false
            samplers[prevSampler].stop()
            accTime = 0.0

func changeSong(song):
    var new_song = song % music.size()
    if new_song == currSong:
        print("Same Song")
        return
    print("Prev Song: " + String(currSong) + " New Song:" + String(song))
    currSong = song % music.size()
    prevSampler = currSampler
    currSampler = (currSampler + 1) % samplers.size()
    print("CurrSamp: " + String(currSampler) + " PrevSamp: " + String(prevSampler))
    samplers[currSampler].stream = music[currSong]
    samplers[currSampler].play()

    if init_crossfade || initial_fadein:
        prevVol = 1.0 - samplersVol[prevSampler]
        initial_fadein = true

    accTime = 0.0
    init_crossfade = true


func playDoorSound():
    sfx_sampler.play()