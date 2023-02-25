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
var ludwigDefeated = false
#var ludDefeatDialog = false

func _ready():
	MusicController._play_song(2)
	$Player.connect("dead", self, "_try_again")
	Globals.ludwigsHealth += Globals.maxLudwigHealth
	$TextureRect.visible = false
	_beginning_dialogic()
#	_camera_limit()



func _try_again():
	$deathScene/DeathScene/AnimationPlayer.play("deathScene")

	#have animation of coots on ground with try again above
	
func _process(delta):
	_activate_fist_hitbox()
	_lud_defeated()


func _lud_defeated():
	if Globals.ludwigsHealth == 0 && ludwigDefeated == false:
		_lud_defeated_dialog()
#		ludDefeatDialog = true
		MusicController._stop_music()
		ludwigDefeated = true
		

func _activate_fist_hitbox():
	if node_exists(hand):
		if hand.texture == handFist:
			$Hand/hurtBox/CollisionShape2D3.set_deferred("disabled", false)
		else:
			$Hand/hurtBox/CollisionShape2D3.set_deferred("disabled", true)

static func node_exists(node):
	if is_instance_valid(node) and node != null and \
		node is Node and node.is_inside_tree():
		return true
	return false

func _hand_snap():
	if node_exists(hand):
		hand.set_texture(handSnap)
		$Hand._play_snap()
		spawner1._spawn_enemy()
		spawner2._spawn_enemy()
		spawner3._spawn_enemy()
		$changeBack.start()

func _on_changeBack_timeout():
	if node_exists(hand):
		hand.set_texture(handRegular)
		stateTimer.start()


func _on_state_timer_timeout():
	if ludwigDefeated == false:
		_roll_state()

func _roll_state():
	if node_exists(hand):
		var value
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var pickedNumber = rng.randi_range(0, 6)
		match[pickedNumber]:
			[0]:
				animationPlayer.play("hand_forward")
			[1]:
				animationPlayer.play("Hand_Slam")
				hand.set_texture(handFist)
			[2]:
				animationPlayer.play("hand_forward_bottom")
			[3]:
				animationPlayer.play("hand_forward_top")
			[4]:
				_hand_snap()
			[5]:
				_hand_snap()
			[6]:
				_hand_snap()


func _on_AnimationPlayer_animation_finished(anim_name):
	stateTimer.start()


func _lud_defeated_dialog():
	if get_node_or_null('DialogNode') == null:
#		get_tree().paused = true
		var dialog = Dialogic.start('dersBetrayal')
		_ludwig_talk()
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
		dialog.connect('dialogic_signal',self, '_kitchen_catch')
		add_child(dialog)

func _kitchen_catch(argument):#has to be the word argument
	if argument == 'kitchenSignal':
		$kitchenTransition/kitchenTransition/AnimationPlayer.play("kitchenTransition")
	if argument == 'lud_explode_start':
		ludwigEyeAnimation.play("explodeStart")
	if argument == 'lud_explode_finish':
		ludwigEyeAnimation.play("explodeFinish")
		$Cage/AnimationPlayer.play("cage_explode")

func _beginning_dialogic():
	if get_node_or_null('DialogNode') == null:
		get_tree().paused = true
		var dialog = Dialogic.start('ludwigBattle')
		_ludwig_talk()
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause_lud')
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

func _unpause_lud(timeline_name):
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
