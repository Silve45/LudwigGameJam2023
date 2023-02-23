extends Node2D
export var finished = false
onready var animationPlayer = $AnimationPlayer

func _ready():
	$Player.connect("dead", self, "_try_again")
	animationPlayer.play("qtIconUpAndDown")

func _try_again():
	$CanvasLayer/DeathScene/AnimationPlayer.play("deathScene")

func _process(delta):
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
