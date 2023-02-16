extends Node

var health = 3
var maxHealth = 3

func _process(delta):
	if Globals.health <= 0:
		Globals.health = 0
	if health >= maxHealth:
		health = maxHealth
func _ready():
	pass # Replace with function body.



