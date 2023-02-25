extends Sprite

onready var hurtBox = $hurtBox
onready var soundEffects = $soundEffects 
onready var snap = load("res://assets/soundEffects/snap.mp3")

func _ready():
	pass # Replace with function body.

func _play_snap():
	soundEffects.stream = snap
	soundEffects.play()

func _process(delta):
	_ludwigDead()

func _ludwigDead():
	if Globals.ludwigsHealth == 0:
		$AnimationPlayer.play("handDead")

func _on_hurtBox_area_entered(area):
	Globals.ludwigsHealth -= 1


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "handDead":
		queue_free()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "handDead":
		$hurtBox/CollisionShape2D.set_deferred("disabled", true)
		$hurtBox/CollisionShape2D2.set_deferred("disabled", true)
		$hurtBox/CollisionShape2D3.set_deferred("disabled", true)
