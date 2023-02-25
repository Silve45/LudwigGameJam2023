extends Control

onready var icon = $Icons/Icon 

onready var ludwigPic = load("res://assets/sprites/friendIcons/ludwigIcon.png")
onready var cootsPic = load("res://assets/sprites/friendIcons/cootsIcon.png")
onready var qtPic = load("res://assets/sprites/friendIcons/qtIcon.png")
onready var dersPic = load("res://assets/sprites/friendIcons/dursIcon.png")
onready var animationPlayer = $AnimationPlayer


func _ready():
	MusicController._play_song(1)
	_debug_dialogic()


func _debug_dialogic():
	if get_node_or_null('DialogNode') == null:
#		get_tree().paused = true
		var dialog = Dialogic.start('Set_up')
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
		dialog.connect('dialogic_signal',self, '_kitchen_catch')
		add_child(dialog)
		print("pausing for dialog")

func _kitchen_catch(argument):
	if argument == "coots":
		icon.set_texture(cootsPic)
	if argument == "ludwig":
		icon.set_texture(ludwigPic)
	if argument == "qt":
		icon.set_texture(qtPic)
	if argument == "ders":
		icon.set_texture(dersPic)

func _unpause(timeline_name):
	get_tree().change_scene("res://scenes/Garage.tscn")
