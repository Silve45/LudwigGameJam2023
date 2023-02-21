extends Node2D

export (PackedScene) var spawnIN: PackedScene = null
export var entitySpeed = 200
export var entityRight = true

onready var spawnNode = $SpawnNode
onready var inBetweenTimer = $inBetweenTimer

var spawnNum = 0 


func _ready():
	pass # Replace with function body.

func _process(delta):
	if spawnNum == 0:
		_spawn_enemy()
#	_spawnNum()

func _spawn_enemy():
	if spawnNode.get_child_count() == 0:
		var spawn : Node2D = spawnIN.instance()
		spawnNode.add_child(spawn)
		spawnNum += 1
		_spawnNum()
		if spawnIN == load("res://scenes/hazards/walkFowardOnly.tscn"):
			spawn.speed = entitySpeed
			spawn.right = entityRight
			print("step1")
	else:
		pass

func _spawnNum():
	if spawnNum == 0:
		pass
	if spawnNum > 0:
		inBetweenTimer.start()

func _on_inBetweenTimer_timeout():
	_spawn_enemy()
