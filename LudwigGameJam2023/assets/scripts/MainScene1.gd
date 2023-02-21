extends Node2D
export var finished = false

func _ready():
	pass
	$Player.connect("dead", self, "_try_again")
#	_camera_limit()

func _try_again():
	$CanvasLayer/DeathScene/AnimationPlayer.play("deathScene")
	#have animation of coots on ground with try again above
	
func _process(delta):
#	if Input.is_action_just_pressed("debug"):
#		_debug_dialogic()
	pass

func _debug_dialogic():
	if get_node_or_null('DialogNode') == null:
		get_tree().paused = true
		var dialog = Dialogic.start('TrialTimeline')
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
		add_child(dialog)
		print("pausing for dialog")


func _unpause(timeline_name):
	get_tree().paused = false
#	print("unpause")

func _camera_limit():
	var tilemap_rect = get_parent().get_node("MainScene1/TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("MainScene1/TileMap").cell_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y 
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
