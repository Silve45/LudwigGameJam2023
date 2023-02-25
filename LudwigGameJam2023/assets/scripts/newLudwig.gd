extends Node2D

onready var face = $face
var deadSprite = load("res://assets/sprites/gameSprites/LudwigFace/Lud-Hurt.png")

func _ready():
	pass # Replace with function body.

func _death():
	pass

func _low_health():
	pass

func _process(delta):
	pass


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "explodeStart":
		face.set_texture(deadSprite)
