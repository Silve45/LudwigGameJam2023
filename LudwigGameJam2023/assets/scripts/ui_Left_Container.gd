extends Control

onready var progressBar = $VBoxContainer/ProgressBar

func _ready():
	pass # Replace with function body.

func _process(delta):
	progressBar.value = Globals.chargeHairBall
	_full_charge()

func _full_charge():
	#in full release chargeBar will have its own sprite 
	if Globals.chargeHairBall == 99:
		progressBar.modulate = Color.red
	else:
		progressBar.modulate = Color.white

