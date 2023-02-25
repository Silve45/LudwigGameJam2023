extends Sprite

onready var animationPlayer = $AnimationPlayer

func _ready():
	pass # Replace with function body.




func _on_Area2D_area_entered(area):
	animationPlayer.play("boxShiver")
