extends Control

#onready var progressBar = $VBoxContainer/ProgressBar
onready var newProgressBar = $VBoxContainer/TextureProgress


func _ready():
	pass # Replace with function body.

func _process(delta):
#	progressBar.value = Globals.chargeHairBall
	newProgressBar.value = Globals.chargeHairBall
	_full_charge()

func _full_charge():
	#in full release chargeBar will have its own sprite 
#	if Globals.chargeHairBall == 100:
#		progressBar.modulate = Color.red
#	else:
#		progressBar.modulate = Color.white
	if Globals.chargeHairBall == 100:
		newProgressBar.modulate = "2ce8f4"
	else:
		newProgressBar.modulate = "ffffff"

