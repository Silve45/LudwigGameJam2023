extends Control


func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "kitchenTransition":
		get_tree().change_scene("res://scenes/Kitchen.tscn")
