extends Control

onready var xButton = $XButton

func _ready():
	pass
#	xButton.grab_focus()

func _make_visible():
	$".".visible = true
	xButton.grab_focus()

func _make_invisbile():
	$".".visible = false


func _on_XButton_pressed():
	_make_invisbile()
