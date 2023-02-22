extends Control

var doOnce = false

func _ready():
	visible = false


func _process(delta):
	_visble()

func _visble():
	if visible == true && doOnce == false:
		$VBoxContainer/RestartLevel.grab_focus()
		doOnce = true
	elif visible == false:
		pass
		
func _on_RestartLevel_pressed():
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	get_tree().change_scene("res://scenes/beginningScene.tscn")
