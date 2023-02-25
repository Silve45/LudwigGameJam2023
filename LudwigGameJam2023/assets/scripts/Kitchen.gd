extends Node2D
export var finished = false

onready var animationPlayer = $AnimationPlayer
onready var zoneTimer = $zoneTimer
onready var drinkTimer = $drinkTimer

var top = false
var middle = false
var bottom = false
var interupted = false

var zone1 = false
var zone2 = false
var zone3 = false


func _ready():
	$Player.connect("dead", self, "_try_again")
	_beginng_Dialog()
	$towerHealthBar.visible = false
	$AnimationPlayer.play("RESET")
	$catTower.connect("boom", self, "_interupted")
#	_camera_limit()

func _zone1():
	if Globals.catTowerHealth == 11 && zone1 == false:
		animationPlayer.play("push")
		zone1 = true
		zoneTimer.start()

func _zone2():
	if Globals.catTowerHealth == 7 && zone2 == false:
		animationPlayer.play("push")
		zone2 = true
		zoneTimer.start()

func _zone3():
	if Globals.catTowerHealth == 4 && zone3 == false:
		animationPlayer.play("push")
		zone3 = true
		zoneTimer.start()


func _on_zoneTimer_timeout():
	animationPlayer.play_backwards("push")

func _drinking():
	drinkTimer.start()
	$ders/AnimationPlayer.play("jump up")

func _on_drinkTimer_timeout():
	Globals.catTowerHealth += 1
	$ders/AnimationPlayer.play("idle")

func _interupted():
	drinkTimer.stop()
	$ders/AnimationPlayer.play("idle")

func _try_again():
	$CanvasLayer/DeathScene/AnimationPlayer.play("deathScene")
	#have animation of coots on ground with try again above
	
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		_drinking()
	if Input.is_action_just_pressed("debug2"):
		animationPlayer.play("clawSwipeVertical")
	if Input.is_action_just_pressed("debug3"):
		animationPlayer.play("clawSwipeHorizontal")
	_zone1()
	_zone2()
	_zone3()


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
#	print("unpause")

func _camera_limit():
	var tilemap_rect = get_parent().get_node("MainScene1/TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("MainScene1/TileMap").cell_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y 
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "top_to_middle" || anim_name == "bottom_to_middle":
		middle = true
		top = false
		bottom = false 
		$ders/AnimationPlayer.play("RESET")
		print("middle")
	if anim_name == "top_to_bottom" || anim_name == "middle_to_bottom":
		bottom = true
		middle = false
		top = false
		$ders/AnimationPlayer.play("RESET")
		print("bottom")
	if anim_name == "bottom_to_top" || anim_name == "middle_to_top":
		top = true 
		middle = false
		bottom = false
		$ders/AnimationPlayer.play("RESET")
		print("top")

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "top_to_middle" || anim_name == "bottom_to_middle" || anim_name == "bottom_to_top" || anim_name == "middle_to_top" || "top_to_bottom" || anim_name == "middle_to_bottom":
		$ders/AnimationPlayer.play("jump down")
	else:
		pass






