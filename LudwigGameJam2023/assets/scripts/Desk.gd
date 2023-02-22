extends Node2D
export var finished = false
onready var ludwigAnimation = $Ludwig/AnimationPlayer
onready var animationPlayer = $AnimationPlayer
onready var stateTimer = $state_timer

var handRegular = load("res://assets/sprites/gameSprites/ludwigSprite/LudwigHand.png")
var handSnap = load("res://assets/sprites/gameSprites/ludwigSprite/SnapLudwig.png")

func _ready():
	$Player.connect("dead", self, "_try_again")
	Globals.ludwigsHealth += Globals.maxLudwigHealth
	$TextureRect.visible = false
#	_beginning_dialogic()
#	_camera_limit()



func _try_again():
	$deathScene/DeathScene/AnimationPlayer.play("deathScene")

	#have animation of coots on ground with try again above
	
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		animationPlayer.play("hand_forward")
	if Input.is_action_just_pressed("debug2"):
		animationPlayer.play("Hand_Slam")
	if Input.is_action_just_pressed("debug3"):
		_roll_state()

func _hand_snap():
	$Hand.set_texture(handSnap)
	$changeBack.start()

func _on_changeBack_timeout():
	$Hand.set_texture(handRegular)
	stateTimer.start()


func _on_state_timer_timeout():
	_roll_state()

func _roll_state():
	var value
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pickedNumber = rng.randi_range(0, 2)
	if pickedNumber == 0:
		animationPlayer.play("hand_forward")
		print("state 1")
	if pickedNumber == 1:
		animationPlayer.play("Hand_Slam")
		print("state 2")
	if pickedNumber == 2:
		_hand_snap()
		print("state 3")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hand_forward":
		stateTimer.start()
	if anim_name == "Hand_Slam":
		stateTimer.start()



func _beginning_dialogic():
	if get_node_or_null('DialogNode') == null:
		get_tree().paused = true
		var dialog = Dialogic.start('ludwigBattle')
		_ludwig_talk()
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
		dialog.connect('dialogic_signal',self, '_begin_fight')
		add_child(dialog)
		print("pausing for dialog")

func _begin_fight(argument):#has to be the word argument
	if argument == 'begin_fight':
		$AnimationPlayer.play("GO")
		print("Begin Fight")
	 #just have hands start and flash fight onScreen

func _ludwig_talk():
	ludwigAnimation.play("talk")

func _ludwig_talk_stop():
	ludwigAnimation.play("RESET")

func _unpause(timeline_name):
	get_tree().paused = false
	_ludwig_talk_stop()
#	print("unpause")

func _camera_limit():
	var tilemap_rect = get_parent().get_node("MainScene1/TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("MainScene1/TileMap").cell_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y 
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y

