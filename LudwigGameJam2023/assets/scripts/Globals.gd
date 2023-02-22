extends Node

var health = 3
var maxHealth = 3
var chargeHairBall = 0
var ludwigsHealth = 10
var maxLudwigHealth = 10

func _process(delta):
	if Globals.health <= 0:
		Globals.health = 0
	if health >= maxHealth:
		health = maxHealth
	
	if Globals.ludwigsHealth <= 0:
		Globals.ludwigsHealth = 0
	if ludwigsHealth >= maxLudwigHealth:
		ludwigsHealth = maxLudwigHealth

func _ready():
	pass # Replace with function body.



