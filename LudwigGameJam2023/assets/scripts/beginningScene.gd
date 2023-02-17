extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("beginningCutscene")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "beginningCutscene":
		get_tree().change_scene("res://scenes/titleScreen.tscn")#will be titleScreen in final version
