extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("Credits")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Credits":
		#add a speical var to give special thing on beginning screen
		get_tree().change_scene("res://scenes/beginningScene.tscn")
