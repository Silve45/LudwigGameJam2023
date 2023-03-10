extends Sprite

onready var explosion = load("res://assets/soundEffects/explosionSound.wav")
onready var soundEffects = $AudioStreamPlayer
onready var animationPlayer = $AnimationPlayer

var towerDead = false
signal boom

func _ready():
	pass # Replace with function body.

func _process(delta):
	_tower_dead()

func _on_hurtBox_area_entered(area):
	Globals.catTowerHealth -= 1
	animationPlayer.play("towerHurt")
	emit_signal("boom")

func _tower_dead():
	if Globals.catTowerHealth == 0 && towerDead == false:
		animationPlayer.play("towerDead")
		soundEffects.stream = explosion
		soundEffects.volume_db = -10
		soundEffects.play()
		towerDead = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "towerDead":
		queue_free()
