extends Control


func _ready():
	visible = false

func _process(delta):
	pass
#	if Input.is_action_just_pressed("debug"):
#		$AnimationPlayer.play("deathScene")

func _on_RestartLevel_pressed():
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	get_tree().change_scene("res://scenes/beginningScene.tscn")
