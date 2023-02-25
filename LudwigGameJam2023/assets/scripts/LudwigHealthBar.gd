extends Control

#onready var healthBar = $VBoxContainer/HealthBar
onready var textureHealthBar = $VBoxContainer/textureHealthBar

func _ready():
	pass

func _process(delta):
#	healthBar.value = Globals.ludwigsHealth
	textureHealthBar.value = Globals.ludwigsHealth
	textureHealthBar.max_value = Globals.maxLudwigHealth
	
