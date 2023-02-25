extends KinematicBody2D

onready var label = $Label
onready var rayCast = $RayCast2D
onready var animationPlayer = $AnimationPlayer
onready var hitBox = $hitBox
onready var soundEffects = $soundEffects

onready var meow = load("res://assets/soundEffects/MeowSoundEffect.mp3")
onready var hairballSound = load("res://assets/soundEffects/hairBall.wav")
onready var attackSound = load("res://assets/soundEffects/attackCoots.wav")

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
	if canMove == true:
		_read_input()
		_ranged_attack()
		_attack()
	_flip_raycast()
	_facing_right()
	_die()
	_meow()

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
			hitBox.set_scale(Vector2(1,1 ))
			animationPlayer.play("run")
			right = true
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			label.set_text("left")
			sprite.set_scale(Vector2(-0.094,0.094))#flip coots to face left
			hitBox.set_scale(Vector2(-1, 1 ))
			animationPlayer.play("run")
			right = false
		if Input.is_action_pressed("down"):
			velocity.y += 1
			label.set_text("down")

			animationPlayer.play("run")
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			label.set_text("up")
			animationPlayer.play("run")
		if velocity == Vector2.ZERO:
			animationPlayer.play("idle")
			label.set_text("idle")
			$hitBox/CollisionShape2D.set_deferred("disabled", true)#making sure it is off
		velocity = velocity.normalized()
		move_and_slide(velocity * speed)

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
		soundEffects.stream = hairballSound
		soundEffects.volume_db = -15
		soundEffects.play()
		_shoot()
	elif Input.is_action_just_released("attack2") && Globals.chargeHairBall < 100:
		print("attack2Failed")
		Globals.chargeHairBall = 0


func _meow():
	if Input.is_action_just_pressed("meow"):
		soundEffects.stream = meow
		soundEffects.volume_db = 5
		soundEffects.play()


func _shoot():
	rayCast.enabled = false
	if Hairball:
		var bullet : Node2D = Hairball.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = rayCast.global_position
		bullet.global_rotation = rayCast.rotation

func receive_knockback(damage_source_pos: Vector2, recivied_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = recivied_damage * knockback_modifier
		var knockback = knockback_direction * knockback_modifier
		
		global_position += knockback

func _hurt(area):
	receive_knockback(area.global_position, 1)
	Globals.health -= 1
	canMove = false
	animationPlayer.play("hurtCoots")

func _on_hurtBox_area_entered(area):
	_hurt(area)
	print("hurt area")


func _on_hurtBox_body_entered(body):
	_hurt(body)
	print("hurt body")

func _attack():
	if Input.is_action_just_pressed("attack1"):
		Globals.chargeHairBall = 0
		soundEffects.stream = attackSound
		soundEffects.volume_db = -20
		soundEffects.play()
		animationPlayer.play("scratch")
		canMove = false
		print("attack")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurtCoots":
		canMove = true
	if anim_name == "scratch":
		canMove = true
		$hitBox/CollisionShape2D.set_deferred("disabled", true)

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
