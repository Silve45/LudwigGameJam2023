extends KinematicBody2D

export var right = true
var direction
#const RIGHT = Vector2.RIGHT
export(int) var SPEED: int = 200

func _ready():
	if right == true:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT


func _physics_process(delta):
	var movement = direction * SPEED * delta
	global_position += movement
