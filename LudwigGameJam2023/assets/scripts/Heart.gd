extends TextureRect

export (int) var whichHeart = 0
var heartFull = load("res://assets/sprites/gameSprites/heartSprite/Heart.png")
var heartEmpty = load("res://assets/sprites/gameSprites/heartSprite/Heart_Gone.png")
func _ready():
	pass # Replace with function body.

func _process(delta):
	_check_heart()

func _check_heart():
	if whichHeart <= Globals.health:
		$".".set_texture(heartFull)
	else:
		$".".set_texture(heartEmpty)
