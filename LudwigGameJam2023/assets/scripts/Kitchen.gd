extends Node2D
export var finished = false

onready var animationPlayer = $AnimationPlayer
onready var zoneTimer = $zoneTimer
onready var drinkTimer = $drinkTimer
onready var healParticles = $heal
onready var stateTimer = $stateTimer
#onready var stateTimerDrink = $stateTimerDrink
onready var clawSwipes = $ClawSwipes
onready var clawSwipesHorizontal = $ClawSwipesHorizontal

var top = false
var middle = false
var bottom = false
var interupted = false
var defeated = false

var zone1 = false
var zone2 = false
var zone3 = false
var isDrinking = false

static func node_exists(node):
	if is_instance_valid(node) and node != null and \
		node is Node and node.is_inside_tree():
		return true
	return false

func _end_Dialog():
	if get_node_or_null('DialogNode') == null:
#		get_tree().paused = true
		var dialog = Dialogic.start('dersDefeat')
#		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
#		dialog.connect('timeline_end', self, '_unpause')
		dialog.connect('dialogic_signal',self, '_end_signals')
		add_child(dialog)
		print("pausing for dialog")

func _end_signals(argument):
	if argument == "fadeBlack":
		MusicController._play_song(4)
		$finalFade/kitchenTransition/AnimationPlayer.play("kitchenTransition")

func _spawn_enemies():
	$Spawners/Spawner._spawn_enemy()
	$Spawners/Spawner2._spawn_enemy()
	$Spawners/Spawner3._spawn_enemy()
	$Spawners/Spawner4._spawn_enemy()
	stateTimer.start()

func _dead():
	if Globals.catTowerHealth == 0 && defeated == false:
		MusicController._stop_music()
		$AnimationPlayer.play("fall_to_earth")
		defeated = true
		_end_Dialog()
		stateTimer.stop()
		drinkTimer.stop()
#		stateTimerDrink.stop()
		$StaticBody2D.visible = false
		$StaticBody2D/push.set_deferred("disabled", true)
		clawSwipesHorizontal.queue_free()
		clawSwipes.queue_free()
		

func _ready():
	Globals.catTowerHealth = Globals.maxCatTowerHealth
	MusicController._play_song(3)
	$Player.connect("dead", self, "_try_again")
	_beginng_Dialog()
	$towerHealthBar.visible = false
	$AnimationPlayer.play("RESET")
	$catTower.connect("boom", self, "_interupted")
#	_camera_limit()

func _zone1():
	if Globals.catTowerHealth == 18 && zone1 == false:
		$pushAnimationPlayer.play("push")
		zone1 = true
		zoneTimer.start()

func _zone2():
	if Globals.catTowerHealth == 11 && zone2 == false:
		$pushAnimationPlayer.play("push")
		zone2 = true
		zoneTimer.start()

func _zone3():
	if Globals.catTowerHealth == 6 && zone3 == false:
		$pushAnimationPlayer.play("push")
		zone3 = true
		zoneTimer.start()


func _on_zoneTimer_timeout():
		$pushAnimationPlayer.play_backwards("push")

func _drinking():
	drinkTimer.start()
	healParticles.emitting = true
	$ders/AnimationPlayer.play("jump up")
	isDrinking = true


func _emergency_stop_drinking():
	if Globals.catTowerHealth == Globals.maxCatTowerHealth && isDrinking == true:
		_interupted()
		isDrinking = false

func _on_drinkTimer_timeout():
	Globals.catTowerHealth += 1

func _interupted():
	if isDrinking == true:
		drinkTimer.stop()
		stateTimer.start()
		healParticles.emitting = false
		isDrinking = false
		$ders/AnimationPlayer.play("RESET")
	

func _try_again():
	$CanvasLayer/DeathScene/AnimationPlayer.play("deathScene")
	#have animation of coots on ground with try again above
	
func _process(delta):
	_zone1()
	_zone2()
	_zone3()
#	_emergency_stop_drinking()
	_dead()

func _roll_state():
	var value
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var maxRoll = 6
	var pickedNumber = rng.randi_range(0, maxRoll)
	while(pickedNumber == 4 && Globals.catTowerHealth == Globals.maxCatTowerHealth):
		pickedNumber = rng.randi_range(0, maxRoll)
		print("full health, just keep going")

	match[pickedNumber]:
		[0]:
			if node_exists(clawSwipesHorizontal):
				animationPlayer.play("clawSwipeHorizontal")
		[1]:
			if node_exists(clawSwipesHorizontal):
				animationPlayer.play("clawSwipeHorizontal")
		[2]:
			if node_exists(clawSwipes):
				animationPlayer.play("clawSwipeVertical")
		[3]:
			if node_exists(clawSwipes):
				animationPlayer.play("clawSwipeVertical")
		[4]:
			_drinking()
		[5]:
			_spawn_enemies()
		[6]:
			_spawn_enemies()

func _on_stateTimer_timeout():
	_roll_state()
	print("stateTimerTimeout")



func _beginng_Dialog():
	if get_node_or_null('DialogNode') == null:
		get_tree().paused = true
		var dialog = Dialogic.start('kitchenTimeline')
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		dialog.connect('timeline_end', self, '_unpause')
		dialog.connect('dialogic_signal',self, '_dialog_signals')
		add_child(dialog)
		print("pausing for dialog")

func _dialog_signals(argument):#has to be the word argument
	if argument == 'unveil':
		$fadeIn/fadeIn/AnimationPlayer.play("fadeInScreen")
		$towerHealthBar.visible = true

func _unpause(timeline_name):
	get_tree().paused = false
	_roll_state()
#	print("unpause")

func _camera_limit():
	var tilemap_rect = get_parent().get_node("MainScene1/TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("MainScene1/TileMap").cell_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y 
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "clawSwipeHorizontal" || anim_name == "clawSwipeVertical":
		stateTimer.start()
#	if anim_name == "top_to_middle" || anim_name == "bottom_to_middle":
#		middle = true
#		top = false
#		bottom = false 
#		$ders/AnimationPlayer.play("RESET")
#		print("middle")
#	if anim_name == "top_to_bottom" || anim_name == "middle_to_bottom":
#		bottom = true
#		middle = false
#		top = false
#		$ders/AnimationPlayer.play("RESET")
#		print("bottom")
#	if anim_name == "bottom_to_top" || anim_name == "middle_to_top":
#		top = true 
#		middle = false
#		bottom = false
#		$ders/AnimationPlayer.play("RESET")
#		print("top")

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "top_to_middle" || anim_name == "bottom_to_middle" || anim_name == "bottom_to_top" || anim_name == "middle_to_top" || "top_to_bottom" || anim_name == "middle_to_bottom":
		$ders/AnimationPlayer.play("jump down")
	else:
		pass

