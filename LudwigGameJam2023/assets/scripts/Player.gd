extends KinematicBody2D

onready var label = $Label
onready var animationTree = $AnimationTree
onready var hurtBox = $hurtBox
onready var animationPlayer = $AnimationPlayer
onready var rayCast = $RayCast2D

var emitDead = false #only using for emit
signal dead#call it and have scene disapear around player

export (PackedScene) var Hairball: PackedScene = null
export(float) var speed = 50
export (bool) var receives_knockback = true
export (float) var knockback_modifier = 0.1

var canMove = true#controls hurt and death


func _ready():
	#reset upon death
	emitDead = false
	Globals.health = Globals.maxHealth
	#done reset upon death

func _process(delta):
	if canMove == true:
		_attack()
		_ranged_attack()
		_read_input()
	_die()



func _read_input():
	if canMove == true:
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
		if Globals.chargeHairBall < 100:
			Globals.chargeHairBall += 1.8
		elif Globals.chargeHairBall >= 100:
			Globals.chargeHairBall = 100
		print("hairBall is at ", Globals.chargeHairBall)

	if Input.is_action_just_released("attack2") && Globals.chargeHairBall == 100:
		print("attack2")
		Globals.chargeHairBall = 0
		_shoot()
	elif Input.is_action_just_released("attack2") && Globals.chargeHairBall < 100:
		print("attack2Failed")
		Globals.chargeHairBall = 0

func _shoot():
	rayCast.enabled = false
	if Hairball:
		var bullet : Node2D = Hairball.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = rayCast.global_position
		bullet.global_rotation = rayCast.rotation


func _on_hurtBox_body_entered(body): #for any world hazards
	print("world damage")
	_hurt(body)

func _on_hurtBox_area_entered(area): #for any enemy with hitBox area
	print("area damage")
	_hurt(area)

func _hurt(area):
	receive_knockback(area.global_position, 1)
	Globals.health -= 1
	canMove = false
	animationPlayer.play("hurt")
	

func _die():
	if Globals.health == 0:
		print("die") #will playDeathAnim and restart where you are
		if emitDead == false:
			emit_signal("dead")
			emitDead = true
		canMove = false
		animationPlayer.play("dead")
		label.set_text("dead")
		$hurtBox/CollisionShape2D.set_deferred("disabled", true)
	else:
		pass

func receive_knockback(damage_source_pos: Vector2, recivied_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = recivied_damage * knockback_modifier
		var knockback = knockback_direction * knockback_modifier
		
		global_position += knockback


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurt":
		canMove = true
