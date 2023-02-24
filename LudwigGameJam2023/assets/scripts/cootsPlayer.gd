extends KinematicBody2D

onready var label = $Label
onready var rayCast = $RayCast2D

signal dead#call it and have scene disapear around player

export var right = true
export (PackedScene) var Hairball: PackedScene = null
export(float) var speed = 50
export (bool) var receives_knockback = true
export (float) var knockback_modifier = 0.1

var left = false
var emitDead = false #only using for emit
var canMove = true#controls hurt and death
onready var sprite = get_node("Coots")#gets node of coots for flipping

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
	_ranged_attack()
	_flip_raycast()

func _facing_right():#this will not work
	if right == true:
		pass
	if right == false:
		pass

func _flip_raycast():
	if Input.is_action_just_pressed("right"):
		rayCast.rotation_degrees = 0
	if Input.is_action_just_pressed("left"):
		rayCast.rotation_degrees = 180

func _read_input():
	if canMove == true:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("right"):
			velocity.x += 1
			label.set_text("right")
			sprite.set_scale(Vector2(0.094,0.094))#flip coots to face right
			$AnimationPlayer.play("run")
			right = true
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			label.set_text("left")
			sprite.set_scale(Vector2(-0.094,0.094))#flip coots to face left
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

func _ranged_attack():
	if Input.is_action_pressed("attack2"):
		if Globals.chargeHairBall < 99:
			Globals.chargeHairBall += 1
		elif Globals.chargeHairBall >= 99:
			Globals.chargeHairBall = 99
		print("hairBall is at ", Globals.chargeHairBall)

	if Input.is_action_just_released("attack2") && Globals.chargeHairBall == 99:
		print("attack2")
		Globals.chargeHairBall = 0
		_shoot()
	elif Input.is_action_just_released("attack2") && Globals.chargeHairBall < 99:
		print("attack2Failed")
		Globals.chargeHairBall = 0

func _shoot():
	rayCast.enabled = false
	if Hairball:
		var bullet : Node2D = Hairball.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = rayCast.global_position
		bullet.global_rotation = rayCast.rotation
