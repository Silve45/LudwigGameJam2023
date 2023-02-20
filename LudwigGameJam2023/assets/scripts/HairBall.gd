extends Area2D

const RIGHT = Vector2.RIGHT
export(int) var SPEED: int = 200

func _ready():
	pass 


func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func _destroy():
	queue_free()
	#add more stuff if you have time

func _on_VisibilityNotifier2D_screen_exited():
	_destroy()

