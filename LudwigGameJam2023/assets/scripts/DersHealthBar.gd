extends Control

#onready var healthBar = $VBoxContainer/HealthBar
onready var textureHealthBar = $VBoxContainer/textureHealthBar

func _ready():
	textureHealthBar.max_value = Globals.maxCatTowerHealth

func _process(delta):
#	healthBar.value = Globals.ludwigsHealth
	textureHealthBar.value = Globals.catTowerHealth
	
