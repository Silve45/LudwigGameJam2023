extends KinematicBody2D

onready var label = $Label

var emitDead = false #only using for emit
signal dead#call it and have scene disapear around player

export var right = true
var left = false
export (PackedScene) var Hairball: PackedScene = null
export(float) var speed = 50
export (bool) var receives_knockback = true
export (float) var knockback_modifier = 0.1

var canMove = true#controls hurt and death

func _ready():
	#reset upon death
	emitDead = false
	Globals.health = Globals.maxHealth
#	_facing_right()
	#done reset upon death

func _process(delta):
#	if canMove == true:
	_read_input()
	_facing_right()

func _facing_right():#this will not work
	if right == true:
		pass
	if right == false:
		pass


func _read_input():
	if canMove == true:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("right"):
			velocity.x += 1
			label.set_text("right")
			$AnimationPlayer.play("run")
			right = true
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			label.set_text("left")
			$AnimationPlayer.play("run")
			right = false
		if Input.is_action_pressed("down"):
			velocity.y += 1
			label.set_text("down")
			$AnimationPlayer.play("run")
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			label.set_text("up")
			$AnimationPlayer.play("run")
		if velocity == Vector2.ZERO:
			$AnimationPlayer.play("idle")
			label.set_text("idle")
		velocity = velocity.normalized()
		move_and_slide(velocity * speed)
