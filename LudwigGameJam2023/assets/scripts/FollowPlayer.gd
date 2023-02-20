extends KinematicBody2D

onready var obj = get_node("../Player")
#export (PackedScene) var obj: PackedScene = null
export (int) var speed = 125

func _ready():
	pass # Replace with function body.

static func node_exists(node):
	if is_instance_valid(node) and node != null and \
		node is Node and node.is_inside_tree():
		return true
	return false

func _physics_process(delta):
	if node_exists(obj) == true:
		var dir = (obj.global_position - global_position).normalized()
		rotation = dir.angle()
		move_and_collide(dir * speed * delta)
	if node_exists(obj) == false:
		_success()

func _success():
	#when player is defeated
	pass

func _blow_up():
	#enemy will despawn on impact dealing damage to player
	#future animations will be here
	queue_free()

func _on_collisionBox_area_entered(area):
	_blow_up()
