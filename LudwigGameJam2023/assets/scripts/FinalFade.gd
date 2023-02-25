extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "kitchenTransition":
		get_tree().change_scene("res://scenes/Credits.tscn")
