extends Area2D

const RIGHT = Vector2.RIGHT
export(int) var SPEED: int = 200
onready var free_timer = $free_timer

func _ready():
	pass 


func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func _destroy():
	$Sprite.visible = false
	$splat.emitting = true
	SPEED = 0
	$CollisionShape2D.set_deferred("disabled", true)
	free_timer.start()
	
	#add more stuff if you have time
func _on_free_timer_timeout():
#	$Sprite.visible = false
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	_destroy()


func _on_HairBall_area_entered(area):#destroy when it hits enemys
	_destroy()

