extends Sprite

onready var exclamtionPoint = $exlamationPoint

func _ready():
	exclamtionPoint.visible = false

func _process(delta):
	_exclamation_point_dialog()

func _dialog():
	if get_node_or_null('DialogNode') == null:
		get_tree().paused = true
		var dialog = Dialogic.start('qtsRequest')
#		_ludwig_talk()
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
#		dialog.connect('dialogic_signal',self, '_begin_fight')
		add_child(dialog)
		print("pausing for dialog")

func _unpause(timeline_name):
	get_tree().paused = false


func _on_Area2D_body_entered(body):
	exclamtionPoint.visible = true
	print("in area")
#	if Input.is_action_just_pressed("ui_accept"):
#		_dialog()

func _exclamation_point_dialog():
	if exclamtionPoint.visible == true && Input.is_action_just_pressed("interact"):
		_dialog()
	else:
		pass

func _on_Area2D_body_exited(body):
	print("out of area")
	exclamtionPoint.visible = false
