extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("beginningCutscene")
	_play_music()
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "beginningCutscene":
		get_tree().change_scene("res://scenes/titleScreen.tscn")#will be titleScreen in final version

func _play_music():
	if MusicController.music.playing == false:
		MusicController._play_song(4)
	else:
		pass
