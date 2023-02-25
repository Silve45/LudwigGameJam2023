extends Node

onready var music = $AudioStreamPlayer

onready var song1 = load("res://assets/music/1-AmazonJungle_Kite_Away_8BIT.mp3")
onready var song2 = load("res://assets/music/2-LudFight_The_Sharpest_Claw_8BIT.mp3")
onready var song3 = load("res://assets/music/3-DersFight_The_Golden_Sun_8BIT.mp3")
onready var song4 = load("res://assets/music/4-Credits_I_Dont_Like_Mondays_8BIT.mp3")

func _ready():
	pass # Replace with function body.

func _play_song(var picked):
	if picked == 1:
		music.stream = song1
		print("song1")
	elif picked == 2:
		music.stream = song2
		print("song2")
	elif picked == 3:
		music.stream = song3
		print("song3")
	elif picked == 4:
		music.stream = song4
		print("song4")
	else:
		music.stream = null #no song
		print("no song")
	music.play()

#func _is_playing_song():
#	if music.stream == song1 && music.playing == true:
#		pass
#	elif music.playing == false:
#		music.play()
	

func _stop_music():
	music.stop()
