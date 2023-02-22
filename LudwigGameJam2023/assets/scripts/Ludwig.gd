extends Node2D



func _ready():
	pass # Replace with function body.


func _on_HurtBox_area_entered(area):
	Globals.ludwigsHealth -= 1
