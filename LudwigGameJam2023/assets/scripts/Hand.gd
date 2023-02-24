extends Sprite


func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_hurtBox_area_entered(area):
	Globals.ludwigsHealth -= 1
