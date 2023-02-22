extends Control

var notPaused = true 
onready var resumeButton = $MarginContainer/HBoxContainer/VBoxContainer/Resume
onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit

func _ready():
	resumeButton.grab_focus()
	visible = false

#func _disable_buttons():
#	if visible == false:
#		resumeButton.disabled = true
#		quitButton.disabled = true
		

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if notPaused:
			get_tree().paused = true 
			notPaused = false 
			visible = true
			resumeButton.grab_focus()
		else:
			get_tree().paused = false 
			notPaused = true
			visible = false 


func _on_Resume_pressed():
	get_tree().paused = false 
	notPaused = true
	visible = false 


func _on_Quit_pressed():
	get_tree().quit()
