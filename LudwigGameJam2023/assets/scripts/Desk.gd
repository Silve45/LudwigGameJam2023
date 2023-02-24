extends Node2D
export var finished = false
onready var ludwigAnimation = $Ludwig/AnimationPlayer
onready var animationPlayer = $AnimationPlayer
onready var stateTimer = $state_timer
onready var hand = $Hand/Hand
onready var ludwigEyeAnimation = $newLudwig/AnimationPlayer
onready var spawner1 = $spawners/Spawner
onready var spawner2 = $spawners/Spawner2
onready var spawner3 = $spawners/Spawner3


var handRegular = load("res://assets/sprites/gameSprites/LudwigHands/Open-Hand.png")
var handSnap = load("res://assets/sprites/gameSprites/LudwigHands/Snap2.png")
var handFist = load("res://assets/sprites/gameSprites/LudwigHands/Fist.png")

func _ready():
	$Player.connect("dead", self, "_try_again")
	Globals.ludwigsHealth += Globals.maxLudwigHealth
	$TextureRect.visible = false
	_beginning_dialogic()
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
	_activate_fist_hitbox()
	

func _activate_fist_hitbox():
	if hand.texture == handFist:
		print("hand is fist")
		$Hand/hurtBox/CollisionShape2D3.set_deferred("disabled", false)
	else:
		print("hand is not fist")
		$Hand/hurtBox/CollisionShape2D3.set_deferred("disabled", true)

func _hand_snap():
	hand.set_texture(handSnap)
	spawner1._spawn_enemy()
	spawner2._spawn_enemy()
	spawner3._spawn_enemy()
	$changeBack.start()

func _on_changeBack_timeout():
	hand.set_texture(handRegular)
	stateTimer.start()


func _on_state_timer_timeout():
	_roll_state()

func _roll_state():
	var value
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pickedNumber = rng.randi_range(0, 4)
	if pickedNumber == 0:
		animationPlayer.play("hand_forward")
		print("state 1")
	if pickedNumber == 1:
		animationPlayer.play("Hand_Slam")
		hand.set_texture(handFist)
		print("state 2")
	if pickedNumber == 2:
		_hand_snap()
		print("state 3")
	if pickedNumber == 3:
		animationPlayer.play("hand_forward_bottom")
	if pickedNumber == 4:
		animationPlayer.play("hand_forward_top")

func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "hand_forward":
#		stateTimer.start()
#	if anim_name == "Hand_Slam":
#		stateTimer.start()
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
		stateTimer.start()
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


var eyeFoward = true
var eyeLeft = false
var eyeRight = false

func _on_frontArea_body_entered(body):
	if eyeLeft == false && eyeRight == false:
		ludwigEyeAnimation.play("eyesFoward")
	if eyeLeft == true:
		ludwigEyeAnimation.play_backwards("eyesLeft")
		eyeLeft = false
	if eyeRight == true:
		ludwigEyeAnimation.play_backwards("eyesRight")
		eyeRight = false
	eyeFoward = true


func _on_leftArea_body_entered(body):
	if eyeLeft == false:
		ludwigEyeAnimation.play("eyesLeft")
	eyeLeft = true
	eyeFoward = false
	eyeRight = false


func _on_rightArea_body_entered(body):
	if eyeRight == false:
		ludwigEyeAnimation.play("eyesRight")
	eyeRight = true
	eyeFoward = false
	eyeLeft = false
