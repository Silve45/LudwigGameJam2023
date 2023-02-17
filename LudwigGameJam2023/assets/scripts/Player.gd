extends KinematicBody2D

onready var label = $Label
onready var animationTree = $AnimationTree
onready var hurtBox = $hurtBox

export(float) var speed = 50
export (bool) var receives_knockback = true
export (float) var knockback_modifier = 0.1

var dead = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	_read_input()
	_die()
	_attack()
	_ranged_attack()

func _read_input():
	if dead == false:
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

func _attack():
	if Input.is_action_just_pressed("attack1"):
		print("attack1")# will attack here. Attack direction is based off of animationTree

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
	elif Input.is_action_just_released("attack2") && Globals.chargeHairBall < 99:
		print("attack2Failed")
		Globals.chargeHairBall = 0


func _on_hurtBox_body_entered(body): #for any world hazards
	receive_knockback(body.global_position, 1)
	print("world damage")
	Globals.health -= 1


func _on_hurtBox_area_entered(area): #for any enemy with hitBox area
	receive_knockback(area.global_position, 1)
	print("area damage")

func _die():
	if Globals.health == 0:
		print("die") #will playDeathAnim and restart where you are
		dead = true
		label.set_text("dead")

func receive_knockback(damage_source_pos: Vector2, recivied_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = recivied_damage * knockback_modifier
		var knockback = knockback_direction * knockback_modifier
		
		global_position += knockback
