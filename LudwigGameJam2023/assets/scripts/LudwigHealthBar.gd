extends Control

onready var healthBar = $VBoxContainer/HealthBar

func _ready():
	pass

func _process(delta):
	healthBar.value = Globals.ludwigsHealth
