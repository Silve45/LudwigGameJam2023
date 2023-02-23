extends Sprite

onready var exclamtionPoint = $exlamationPoint

func _ready():
	exclamtionPoint.visible = false

func _process(delta):
	_exclamation_point_teleport()

func _teleport():
	get_tree().change_scene("res://scenes/Desk.tscn")

func _exclamation_point_teleport():
	if exclamtionPoint.visible == true && Input.is_action_just_pressed("interact"):
		_teleport()
	else:
		pass

func _on_Area2D_body_entered(body):
	exclamtionPoint.visible = true
	print("in area")
#	if Input.is_action_just_pressed("ui_accept"):
#		_dialog()

func _on_Area2D_body_exited(body):
	print("out of area")
	exclamtionPoint.visible = false
