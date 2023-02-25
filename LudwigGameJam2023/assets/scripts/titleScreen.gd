extends Control

export var starSpeed = 3

onready var buttonHolder = $ButtonHolder
onready var animationPlayer = $AnimationPlayer
onready var playButton = $ButtonHolder/Play
onready var cootsSprite = $coots


func _ready():
	buttonHolder.visible = false# make true after anim
	playButton.grab_focus()
	cootsSprite.visible = false
	animationPlayer.play("titleScreenBeginning")

func _process(delta):
	_move_stars(delta)

func _on_Play_pressed(): #this will have to be changed
	get_tree().change_scene("res://scenes/Desk.tscn")#will be changed to cage 

func _move_stars(delta):
	$StarBackground/StarGround.motion_offset.y += starSpeed * delta


func _on_I_dont_know_pressed():
		OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
