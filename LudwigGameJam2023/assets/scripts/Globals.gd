extends Node

var health = 3
var maxHealth = 3
var chargeHairBall = 0
var ludwigsHealth = 20
var maxLudwigHealth = 20
var catTowerHealth = 25
var maxCatTowerHealth = 25

var gameFinished = false

func _process(delta):
	if Globals.health <= 0:
		Globals.health = 0
	if health >= maxHealth:
		health = maxHealth
	
	if Globals.ludwigsHealth <= 0:
		Globals.ludwigsHealth = 0
	if ludwigsHealth >= maxLudwigHealth:
		ludwigsHealth = maxLudwigHealth
	
	if catTowerHealth <= 0:
		catTowerHealth = 0
	if catTowerHealth >= maxCatTowerHealth:
		catTowerHealth = maxCatTowerHealth

func _ready():
	pass # Replace with function body.



