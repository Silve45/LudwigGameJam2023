extends KinematicBody2D

onready var label = $Label
onready var animationTree = $AnimationTree
export(float) var speed = 50



func _ready():
	pass # Replace with function body.

func _process(delta):
	_read_input()

func _read_input():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
		label.set_text("right")
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		label.set_text("left")
	if Input.is_action_pressed("down"):
		velocity.y += 1
		label.set_text("down")
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		label.set_text("up")
	velocity = velocity.normalized()
	
	if velocity == Vector2.ZERO:
		animationTree.get("parameters/playback").travel("idle")
		label.set_text("idle")
	else:
		animationTree.get("parameters/playback").travel("walk")
		animationTree.set("parameters/idle/blend_position", velocity)
		animationTree.set("parameters/walk/blend_position", velocity)
		move_and_slide(velocity * speed)
	
	
	

