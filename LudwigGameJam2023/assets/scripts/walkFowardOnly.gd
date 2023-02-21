extends KinematicBody2D

export var right = true
var direction
#const RIGHT = Vector2.RIGHT
export(int) var speed: int = 200

func _ready():
	_get_right()

func _get_right():
	if right == true:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func _physics_process(delta):
	var movement = direction * speed * delta
	global_position += movement
	_get_right()# has to be here as well just in case of spawner
	

func _on_VisibilityNotifier2D_screen_exited():
	_die()

func _die():
	#add animation later
	queue_free()
